import SwiftData

@MainActor
enum LegacyPhotoMigrationService {
    @discardableResult
    static func migratePhotos(
        in context: ModelContext,
        photoStorage: PhotoStorageService = .shared
    ) throws -> Int {
        let items = try context.fetch(FetchDescriptor<StoredItem>())
        var migratedFiles: [String] = []

        for item in items where item.photoData == nil {
            guard let fileName = item.photoFileName,
                  let image = photoStorage.loadLegacyImage(fileName: fileName),
                  let data = try? photoStorage.makeSyncableData(from: image) else {
                continue
            }

            item.photoData = data
            item.photoFileName = nil
            item.updatedAt = .now
            migratedFiles.append(fileName)
        }

        guard !migratedFiles.isEmpty else {
            return 0
        }

        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }

        migratedFiles.forEach {
            photoStorage.deleteLegacyImage(fileName: $0)
        }

        return migratedFiles.count
    }
}
