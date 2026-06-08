import Foundation
import SwiftData

struct StorageMigrationManifest: Codable, Equatable {
    let itemUpdateDates: [String: Date]
}

enum StorageMigrationManifestStore {
    private static let key = "cloudSyncMigrationBaseline"

    static func load(
        defaults: UserDefaults = .standard
    ) -> StorageMigrationManifest? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }

        return try? JSONDecoder().decode(
            StorageMigrationManifest.self,
            from: data
        )
    }

    static func save(
        _ manifest: StorageMigrationManifest,
        defaults: UserDefaults = .standard
    ) throws {
        defaults.set(
            try JSONEncoder().encode(manifest),
            forKey: key
        )
    }

    static func remove(defaults: UserDefaults = .standard) {
        defaults.removeObject(forKey: key)
    }
}

@MainActor
enum StorageMigrationService {
    @discardableResult
    static func prepareLocalStore(
        from cloudContext: ModelContext,
        into localContext: ModelContext
    ) throws -> StorageMigrationManifest {
        let cloudSnapshots = try snapshots(in: cloudContext)
        let cloudIDs = Set(cloudSnapshots.map(\.id))
        let localItems = try localContext.fetch(FetchDescriptor<StoredItem>())
        let localItemsByID = Dictionary(
            uniqueKeysWithValues: localItems.map { ($0.id, $0) }
        )

        for localItem in localItems where !cloudIDs.contains(localItem.id) {
            localContext.delete(localItem)
        }

        for snapshot in cloudSnapshots {
            if let localItem = localItemsByID[snapshot.id] {
                snapshot.apply(to: localItem)
            } else {
                localContext.insert(snapshot.makeStoredItem())
            }
        }

        try localContext.save()

        return StorageMigrationManifest(
            itemUpdateDates: Dictionary(
                uniqueKeysWithValues: cloudSnapshots.map {
                    ($0.id.uuidString, $0.updatedAt)
                }
            )
        )
    }

    static func mergeLocalStore(
        from localContext: ModelContext,
        into cloudContext: ModelContext,
        baseline: StorageMigrationManifest?
    ) throws {
        let localSnapshots = try snapshots(in: localContext)
        let localIDs = Set(localSnapshots.map(\.id))
        let cloudItems = try cloudContext.fetch(FetchDescriptor<StoredItem>())
        let cloudItemsByID = Dictionary(
            uniqueKeysWithValues: cloudItems.map { ($0.id, $0) }
        )

        for snapshot in localSnapshots {
            let baselineDate = baseline?.itemUpdateDates[snapshot.id.uuidString]
            let changedLocally = baselineDate.map {
                snapshot.updatedAt > $0
            } ?? true

            if let cloudItem = cloudItemsByID[snapshot.id] {
                if changedLocally && snapshot.updatedAt >= cloudItem.updatedAt {
                    snapshot.apply(to: cloudItem)
                }
            } else if changedLocally {
                cloudContext.insert(snapshot.makeStoredItem())
            }
        }

        if let baseline {
            for (idString, baselineDate) in baseline.itemUpdateDates {
                guard let id = UUID(uuidString: idString),
                      !localIDs.contains(id),
                      let cloudItem = cloudItemsByID[id],
                      cloudItem.updatedAt <= baselineDate else {
                    continue
                }

                cloudContext.delete(cloudItem)
            }
        }

        try cloudContext.save()
    }

    private static func snapshots(
        in context: ModelContext
    ) throws -> [StoredItemSnapshot] {
        try context.fetch(FetchDescriptor<StoredItem>())
            .map(StoredItemSnapshot.init)
    }
}

private struct StoredItemSnapshot {
    let id: UUID
    let modelVersion: Int
    let name: String
    let categoryRawValue: String
    let place: String
    let room: String
    let container: String
    let exactSpot: String
    let privateNote: String
    let photoData: Data?
    let photoFileName: String?
    let sensitivityRawValue: String
    let createdAt: Date
    let updatedAt: Date
    let lastCheckedAt: Date?
    let reminderDate: Date?
    let reminderFrequencyRawValue: String
    let isArchived: Bool

    init(item: StoredItem) {
        id = item.id
        modelVersion = item.modelVersion
        name = item.name
        categoryRawValue = item.categoryRawValue
        place = item.place
        room = item.room
        container = item.container
        exactSpot = item.exactSpot
        privateNote = item.privateNote
        photoData = item.photoData
        photoFileName = item.photoFileName
        sensitivityRawValue = item.sensitivityRawValue
        createdAt = item.createdAt
        updatedAt = item.updatedAt
        lastCheckedAt = item.lastCheckedAt
        reminderDate = item.reminderDate
        reminderFrequencyRawValue = item.reminderFrequencyRawValue
        isArchived = item.isArchived
    }

    func makeStoredItem() -> StoredItem {
        StoredItem(
            id: id,
            modelVersion: modelVersion,
            name: name,
            categoryRawValue: categoryRawValue,
            place: place,
            room: room,
            container: container,
            exactSpot: exactSpot,
            privateNote: privateNote,
            photoData: photoData,
            photoFileName: photoFileName,
            sensitivityRawValue: sensitivityRawValue,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastCheckedAt: lastCheckedAt,
            reminderDate: reminderDate,
            reminderFrequencyRawValue: reminderFrequencyRawValue,
            isArchived: isArchived
        )
    }

    func apply(to item: StoredItem) {
        item.modelVersion = modelVersion
        item.name = name
        item.categoryRawValue = categoryRawValue
        item.place = place
        item.room = room
        item.container = container
        item.exactSpot = exactSpot
        item.privateNote = privateNote
        item.photoData = photoData
        item.photoFileName = photoFileName
        item.sensitivityRawValue = sensitivityRawValue
        item.createdAt = createdAt
        item.updatedAt = updatedAt
        item.lastCheckedAt = lastCheckedAt
        item.reminderDate = reminderDate
        item.reminderFrequencyRawValue = reminderFrequencyRawValue
        item.isArchived = isArchived
    }
}
