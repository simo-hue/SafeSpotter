import UIKit
import XCTest
@testable import SafeSpot

final class PhotoStorageServiceTests: XCTestCase {
    private var temporaryDirectory: URL!
    private var service: PhotoStorageService!

    override func setUpWithError() throws {
        temporaryDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        service = PhotoStorageService(baseDirectoryURL: temporaryDirectory)
    }

    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: temporaryDirectory)
        temporaryDirectory = nil
        service = nil
    }

    func testSaveLoadAndDeleteImage() throws {
        let image = try XCTUnwrap(makeImage())
        let fileName = try service.saveImage(image)

        XCTAssertNotNil(service.loadImage(fileName: fileName))

        service.deleteImage(fileName: fileName)

        XCTAssertNil(service.loadImage(fileName: fileName))
    }

    private func makeImage() -> UIImage? {
        UIGraphicsImageRenderer(size: CGSize(width: 4, height: 4)).image { context in
            UIColor.systemBlue.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 4, height: 4))
        }
    }
}

