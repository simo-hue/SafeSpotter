import Foundation
import UIKit

final class PhotoStorageService {
    static let shared = PhotoStorageService()

    private let maximumPixelDimension: CGFloat
    private let maximumDataSize: Int
    private let fileManager: FileManager
    private let baseDirectoryURL: URL?

    init(
        maximumPixelDimension: CGFloat = 2_048,
        maximumDataSize: Int = 5_000_000,
        fileManager: FileManager = .default,
        baseDirectoryURL: URL? = nil
    ) {
        self.maximumPixelDimension = maximumPixelDimension
        self.maximumDataSize = maximumDataSize
        self.fileManager = fileManager
        self.baseDirectoryURL = baseDirectoryURL
    }

    func makeSyncableData(from image: UIImage) throws -> Data {
        var preparedImage = resizedImage(
            image,
            maximumPixelDimension: maximumPixelDimension
        )

        for quality in [0.82, 0.7, 0.58, 0.46] {
            guard let data = preparedImage.jpegData(compressionQuality: quality) else {
                throw PhotoStorageError.encodingFailed
            }

            if data.count <= maximumDataSize {
                return data
            }
        }

        preparedImage = resizedImage(
            preparedImage,
            maximumPixelDimension: maximumPixelDimension * 0.75
        )

        guard let data = preparedImage.jpegData(compressionQuality: 0.42) else {
            throw PhotoStorageError.encodingFailed
        }

        guard data.count <= maximumDataSize else {
            throw PhotoStorageError.exceedsMaximumSize
        }

        return data
    }

    func image(from data: Data?) -> UIImage? {
        guard let data else {
            return nil
        }

        return UIImage(data: data)
    }

    func loadLegacyImageData(fileName: String?) -> Data? {
        guard let fileName,
              let url = try? photosDirectory().appendingPathComponent(fileName) else {
            return nil
        }

        return try? Data(contentsOf: url, options: .mappedIfSafe)
    }

    func loadLegacyImage(fileName: String?) -> UIImage? {
        image(from: loadLegacyImageData(fileName: fileName))
    }

    func deleteLegacyImage(fileName: String?) {
        guard let fileName,
              let url = try? photosDirectory().appendingPathComponent(fileName),
              fileManager.fileExists(atPath: url.path) else {
            return
        }

        try? fileManager.removeItem(at: url)
    }

    private func resizedImage(
        _ image: UIImage,
        maximumPixelDimension: CGFloat
    ) -> UIImage {
        let sourceWidth = CGFloat(image.cgImage?.width ?? Int(image.size.width * image.scale))
        let sourceHeight = CGFloat(image.cgImage?.height ?? Int(image.size.height * image.scale))
        let largestDimension = max(sourceWidth, sourceHeight)

        guard largestDimension > maximumPixelDimension else {
            return image
        }

        let scale = maximumPixelDimension / largestDimension
        let targetSize = CGSize(
            width: max(1, (sourceWidth * scale).rounded()),
            height: max(1, (sourceHeight * scale).rounded())
        )
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1

        return UIGraphicsImageRenderer(size: targetSize, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    private func photosDirectory() throws -> URL {
        let baseURL = baseDirectoryURL
            ?? fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        let directory = baseURL
            .appendingPathComponent("SafeSpot", isDirectory: true)
            .appendingPathComponent("ItemPhotos", isDirectory: true)

        if !fileManager.fileExists(atPath: directory.path) {
            try fileManager.createDirectory(
                at: directory,
                withIntermediateDirectories: true,
                attributes: [.protectionKey: FileProtectionType.complete]
            )
        }

        return directory
    }
}

enum PhotoStorageError: Error {
    case encodingFailed
    case exceedsMaximumSize
}
