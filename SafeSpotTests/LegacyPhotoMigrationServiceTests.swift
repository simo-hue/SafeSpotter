import SwiftData
import UIKit
import XCTest
@testable import SafeSpot

@MainActor
final class LegacyPhotoMigrationServiceTests: XCTestCase {
    private var temporaryDirectory: URL!

    override func setUpWithError() throws {
        temporaryDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
    }

    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: temporaryDirectory)
        temporaryDirectory = nil
    }

    func testMigratesLegacyPhotoAfterSavingModelData() throws {
        let legacyFileName = "legacy-photo.jpg"
        let legacyDirectory = temporaryDirectory
            .appendingPathComponent("SafeSpot", isDirectory: true)
            .appendingPathComponent("ItemPhotos", isDirectory: true)
        try FileManager.default.createDirectory(
            at: legacyDirectory,
            withIntermediateDirectories: true
        )
        let legacyURL = legacyDirectory.appendingPathComponent(legacyFileName)
        let legacyData = try XCTUnwrap(makeImage().jpegData(compressionQuality: 0.8))
        try legacyData.write(to: legacyURL)

        let schema = Schema([StoredItem.self])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true,
            cloudKitDatabase: .none
        )
        let modelContainer = try ModelContainer(
            for: schema,
            configurations: [configuration]
        )
        let context = modelContainer.mainContext
        let item = StoredItem(
            name: "Passport",
            photoFileName: legacyFileName
        )
        context.insert(item)
        try context.save()

        let service = PhotoStorageService(
            baseDirectoryURL: temporaryDirectory
        )
        let migratedCount = try LegacyPhotoMigrationService.migratePhotos(
            in: context,
            photoStorage: service
        )

        XCTAssertEqual(migratedCount, 1)
        XCTAssertNotNil(item.photoData)
        XCTAssertNotNil(service.image(from: item.photoData))
        XCTAssertNil(item.photoFileName)
        XCTAssertFalse(FileManager.default.fileExists(atPath: legacyURL.path))
    }

    private func makeImage() -> UIImage {
        UIGraphicsImageRenderer(size: CGSize(width: 8, height: 8)).image { context in
            UIColor.systemPurple.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 8, height: 8))
        }
    }
}
