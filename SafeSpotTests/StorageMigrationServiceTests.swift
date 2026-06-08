import SwiftData
import XCTest
@testable import SafeSpot

@MainActor
final class StorageMigrationServiceTests: XCTestCase {
    func testPreparingLocalStoreCreatesExactCloudSnapshot() throws {
        let cloudContainer = try makeInMemoryContainer()
        let localContainer = try makeInMemoryContainer()
        let itemID = UUID()
        let cloudDate = Date(timeIntervalSince1970: 2_000)

        cloudContainer.mainContext.insert(
            StoredItem(
                id: itemID,
                name: "Passport",
                updatedAt: cloudDate
            )
        )
        localContainer.mainContext.insert(
            StoredItem(
                id: itemID,
                name: "Stale Passport",
                updatedAt: Date(timeIntervalSince1970: 1_000)
            )
        )
        localContainer.mainContext.insert(
            StoredItem(name: "Old Local Item")
        )
        try cloudContainer.mainContext.save()
        try localContainer.mainContext.save()

        let manifest = try StorageMigrationService.prepareLocalStore(
            from: cloudContainer.mainContext,
            into: localContainer.mainContext
        )

        let localItems = try localContainer.mainContext.fetch(
            FetchDescriptor<StoredItem>()
        )
        XCTAssertEqual(localItems.count, 1)
        XCTAssertEqual(localItems.first?.id, itemID)
        XCTAssertEqual(localItems.first?.name, "Passport")
        XCTAssertEqual(
            manifest.itemUpdateDates[itemID.uuidString],
            cloudDate
        )
    }

    func testMergingLocalStoreReconcilesChangesWithoutDiscardingNewerCloudData() throws {
        let localContainer = try makeInMemoryContainer()
        let cloudContainer = try makeInMemoryContainer()
        let editedItemID = UUID()
        let deletedItemID = UUID()
        let newLocalItemID = UUID()
        let remoteItemID = UUID()
        let baselineDate = Date(timeIntervalSince1970: 1_000)
        let localEditDate = Date(timeIntervalSince1970: 2_000)
        let remoteDate = Date(timeIntervalSince1970: 3_000)

        localContainer.mainContext.insert(
            StoredItem(
                id: editedItemID,
                name: "Locally Edited",
                updatedAt: localEditDate
            )
        )
        localContainer.mainContext.insert(
            StoredItem(
                id: newLocalItemID,
                name: "New Local Item",
                updatedAt: localEditDate
            )
        )

        cloudContainer.mainContext.insert(
            StoredItem(
                id: editedItemID,
                name: "Original",
                updatedAt: baselineDate
            )
        )
        cloudContainer.mainContext.insert(
            StoredItem(
                id: deletedItemID,
                name: "Deleted Locally",
                updatedAt: baselineDate
            )
        )
        cloudContainer.mainContext.insert(
            StoredItem(
                id: remoteItemID,
                name: "Added on Another Device",
                updatedAt: remoteDate
            )
        )
        try localContainer.mainContext.save()
        try cloudContainer.mainContext.save()

        let baseline = StorageMigrationManifest(
            itemUpdateDates: [
                editedItemID.uuidString: baselineDate,
                deletedItemID.uuidString: baselineDate
            ]
        )

        try StorageMigrationService.mergeLocalStore(
            from: localContainer.mainContext,
            into: cloudContainer.mainContext,
            baseline: baseline
        )

        let cloudItems = try cloudContainer.mainContext.fetch(
            FetchDescriptor<StoredItem>()
        )
        let cloudItemsByID = Dictionary(
            uniqueKeysWithValues: cloudItems.map { ($0.id, $0) }
        )

        XCTAssertEqual(cloudItemsByID[editedItemID]?.name, "Locally Edited")
        XCTAssertNil(cloudItemsByID[deletedItemID])
        XCTAssertEqual(cloudItemsByID[newLocalItemID]?.name, "New Local Item")
        XCTAssertEqual(
            cloudItemsByID[remoteItemID]?.name,
            "Added on Another Device"
        )
    }

    func testNewerCloudEditWinsOverLocalEdit() throws {
        let localContainer = try makeInMemoryContainer()
        let cloudContainer = try makeInMemoryContainer()
        let itemID = UUID()
        let baselineDate = Date(timeIntervalSince1970: 1_000)

        localContainer.mainContext.insert(
            StoredItem(
                id: itemID,
                name: "Local Edit",
                updatedAt: Date(timeIntervalSince1970: 2_000)
            )
        )
        cloudContainer.mainContext.insert(
            StoredItem(
                id: itemID,
                name: "Newer Cloud Edit",
                updatedAt: Date(timeIntervalSince1970: 3_000)
            )
        )
        try localContainer.mainContext.save()
        try cloudContainer.mainContext.save()

        try StorageMigrationService.mergeLocalStore(
            from: localContainer.mainContext,
            into: cloudContainer.mainContext,
            baseline: StorageMigrationManifest(
                itemUpdateDates: [itemID.uuidString: baselineDate]
            )
        )

        let cloudItem = try XCTUnwrap(
            cloudContainer.mainContext.fetch(
                FetchDescriptor<StoredItem>()
            ).first
        )
        XCTAssertEqual(cloudItem.name, "Newer Cloud Edit")
    }

    func testStorageModeDefaultsToCloudForExistingUpgrades() {
        let suiteName = "StorageMigrationServiceTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }

        XCTAssertEqual(
            PersistenceController.preferredStorageMode(defaults: defaults),
            .cloud
        )

        defaults.set(false, forKey: AppSettingsKey.isCloudSyncEnabled)
        XCTAssertEqual(
            PersistenceController.preferredStorageMode(defaults: defaults),
            .local
        )
    }

    private func makeInMemoryContainer() throws -> ModelContainer {
        let schema = Schema([StoredItem.self])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true,
            cloudKitDatabase: .none
        )

        return try ModelContainer(
            for: schema,
            configurations: [configuration]
        )
    }
}
