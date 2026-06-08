import CoreData
import Foundation
import Observation
import OSLog
import SwiftData

enum PersistenceStorageMode: String, Equatable {
    case local
    case cloud
}

enum PersistenceController {
    static let cloudKitContainerIdentifier = "iCloud.com.safespot"

    static func preferredStorageMode(
        defaults: UserDefaults = .standard
    ) -> PersistenceStorageMode {
        guard defaults.object(forKey: AppSettingsKey.isCloudSyncEnabled) != nil else {
            return .cloud
        }

        return defaults.bool(forKey: AppSettingsKey.isCloudSyncEnabled)
            ? .cloud
            : .local
    }

    static func makeModelContainer(
        storageMode: PersistenceStorageMode,
        isStoredInMemoryOnly: Bool = false
    ) throws -> ModelContainer {
        let schema = Schema([StoredItem.self])
        let configuration: ModelConfiguration

        if isStoredInMemoryOnly {
            configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true,
                cloudKitDatabase: .none
            )
        } else {
            switch storageMode {
            case .cloud:
                configuration = ModelConfiguration(
                    schema: schema,
                    cloudKitDatabase: .private(cloudKitContainerIdentifier)
                )
            case .local:
                configuration = ModelConfiguration(
                    "SafeSpotLocal",
                    schema: schema,
                    url: try localStoreURL(),
                    cloudKitDatabase: .none
                )
            }
        }

        #if DEBUG
        if storageMode == .cloud && !isStoredInMemoryOnly {
            try CloudKitSchemaInitializer.initializeIfRequested(
                configuration: configuration,
                modelTypes: [StoredItem.self]
            )
        }
        #endif

        return try ModelContainer(
            for: schema,
            configurations: [configuration]
        )
    }

    private static func localStoreURL() throws -> URL {
        let applicationSupportURL = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let storeDirectoryURL = applicationSupportURL
            .appendingPathComponent("SafeSpot", isDirectory: true)

        try FileManager.default.createDirectory(
            at: storeDirectoryURL,
            withIntermediateDirectories: true
        )

        return storeDirectoryURL.appendingPathComponent("Local.store")
    }
}

@MainActor
@Observable
final class PersistenceManager {
    private(set) var modelContainer: ModelContainer
    private(set) var storageMode: PersistenceStorageMode
    private(set) var containerID = UUID()
    private(set) var isSwitchingStorage = false
    private(set) var completedStorageChange: PersistenceStorageMode?

    @ObservationIgnored
    private let defaults: UserDefaults
    @ObservationIgnored
    private let isStoredInMemoryOnly: Bool

    init(defaults: UserDefaults = .standard) throws {
        self.defaults = defaults
        isStoredInMemoryOnly = ProcessInfo.processInfo.environment[
            "XCTestConfigurationFilePath"
        ] != nil
        let storageMode = PersistenceController.preferredStorageMode(
            defaults: defaults
        )
        self.storageMode = storageMode
        modelContainer = try PersistenceController.makeModelContainer(
            storageMode: storageMode,
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )
    }

    func switchStorage(to newMode: PersistenceStorageMode) async throws {
        guard newMode != storageMode, !isSwitchingStorage else {
            return
        }

        isSwitchingStorage = true
        defer { isSwitchingStorage = false }

        try modelContainer.mainContext.save()

        let destinationContainer = try PersistenceController.makeModelContainer(
            storageMode: newMode,
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )

        switch (storageMode, newMode) {
        case (.cloud, .local):
            let manifest = try StorageMigrationService.prepareLocalStore(
                from: modelContainer.mainContext,
                into: destinationContainer.mainContext
            )
            try StorageMigrationManifestStore.save(
                manifest,
                defaults: defaults
            )
        case (.local, .cloud):
            let manifest = StorageMigrationManifestStore.load(
                defaults: defaults
            )
            try StorageMigrationService.mergeLocalStore(
                from: modelContainer.mainContext,
                into: destinationContainer.mainContext,
                baseline: manifest
            )
            StorageMigrationManifestStore.remove(defaults: defaults)
        case (.local, .local), (.cloud, .cloud):
            return
        }

        defaults.set(
            newMode == .cloud,
            forKey: AppSettingsKey.isCloudSyncEnabled
        )
        storageMode = newMode
        modelContainer = destinationContainer
        containerID = UUID()
        completedStorageChange = newMode
        await Task.yield()
    }

    func dismissStorageChangeConfirmation() {
        completedStorageChange = nil
    }
}

#if DEBUG
private enum CloudKitSchemaInitializer {
    private static let logger = Logger(
        subsystem: "com.safespot",
        category: "CloudKitSchema"
    )
    private static let launchArgument = "-SafeSpotInitializeCloudKitSchema"

    static func initializeIfRequested(
        configuration: ModelConfiguration,
        modelTypes: [any PersistentModel.Type]
    ) throws {
        guard ProcessInfo.processInfo.arguments.contains(launchArgument) else {
            return
        }

        try autoreleasepool {
            let description = NSPersistentStoreDescription(url: configuration.url)
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
                containerIdentifier: PersistenceController.cloudKitContainerIdentifier
            )
            description.shouldAddStoreAsynchronously = false

            guard let managedObjectModel = NSManagedObjectModel.makeManagedObjectModel(
                for: modelTypes
            ) else {
                throw PersistenceError.couldNotCreateManagedObjectModel
            }

            let container = NSPersistentCloudKitContainer(
                name: "SafeSpot",
                managedObjectModel: managedObjectModel
            )
            container.persistentStoreDescriptions = [description]

            var storeLoadError: Error?
            container.loadPersistentStores { _, error in
                storeLoadError = error
            }

            if let storeLoadError {
                throw storeLoadError
            }

            try container.initializeCloudKitSchema()

            if let store = container.persistentStoreCoordinator.persistentStores.first {
                try container.persistentStoreCoordinator.remove(store)
            }

            logger.info("CloudKit development schema initialized successfully.")
        }
    }
}

private enum PersistenceError: LocalizedError {
    case couldNotCreateManagedObjectModel

    var errorDescription: String? {
        "SafeSpot could not create the managed object model used to initialize CloudKit."
    }
}
#endif
