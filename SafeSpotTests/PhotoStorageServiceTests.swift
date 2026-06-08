import UIKit
import XCTest
@testable import SafeSpot

final class PhotoStorageServiceTests: XCTestCase {
    private var service: PhotoStorageService!

    override func setUpWithError() throws {
        service = PhotoStorageService()
    }

    override func tearDownWithError() throws {
        service = nil
    }

    func testCreatesSyncableImageData() throws {
        let image = try XCTUnwrap(makeImage())
        let data = try service.makeSyncableData(from: image)

        XCTAssertFalse(data.isEmpty)
        XCTAssertNotNil(service.image(from: data))
    }

    func testDownsizesLargeImagesForCloudSync() throws {
        service = PhotoStorageService(maximumPixelDimension: 512)
        let image = UIGraphicsImageRenderer(
            size: CGSize(width: 1_200, height: 600)
        ).image { context in
            UIColor.systemBlue.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 1_200, height: 600))
        }

        let data = try service.makeSyncableData(from: image)
        let decodedImage = try XCTUnwrap(service.image(from: data))
        let pixelWidth = CGFloat(
            decodedImage.cgImage?.width ?? Int(decodedImage.size.width * decodedImage.scale)
        )
        let pixelHeight = CGFloat(
            decodedImage.cgImage?.height ?? Int(decodedImage.size.height * decodedImage.scale)
        )

        XCTAssertLessThanOrEqual(max(pixelWidth, pixelHeight), 512)
    }

    private func makeImage() -> UIImage? {
        UIGraphicsImageRenderer(size: CGSize(width: 4, height: 4)).image { context in
            UIColor.systemBlue.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 4, height: 4))
        }
    }
}
