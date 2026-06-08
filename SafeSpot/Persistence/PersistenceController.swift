import CoreData
import OSLog
import SwiftData

enum PersistenceController {
    static let cloudKitContainerIdentifier = "iCloud.com.safespot"

    static func makeModelContainer() throws -> ModelContainer {
        let schema = Schema([StoredItem.self])
        let configuration = ModelConfiguration(
            schema: schema,
            cloudKitDatabase: .private(cloudKitContainerIdentifier)
        )

        #if DEBUG
        try CloudKitSchemaInitializer.initializeIfRequested(
            configuration: configuration,
            modelTypes: [StoredItem.self]
        )
        #endif

        return try ModelContainer(
            for: schema,
            configurations: [configuration]
        )
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
