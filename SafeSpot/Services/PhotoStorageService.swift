import Foundation
import UIKit

final class PhotoStorageService {
    static let shared = PhotoStorageService()

    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func saveImage(_ image: UIImage) throws -> String {
        let fileName = UUID().uuidString + ".jpg"
        let url = try photosDirectory().appendingPathComponent(fileName)

        guard let data = image.jpegData(compressionQuality: 0.82) else {
            throw PhotoStorageError.encodingFailed
        }

        try data.write(to: url, options: [.atomic, .completeFileProtection])
        return fileName
    }

    func loadImage(fileName: String?) -> UIImage? {
        guard let fileName,
              let url = try? photosDirectory().appendingPathComponent(fileName),
              let data = try? Data(contentsOf: url) else {
            return nil
        }

        return UIImage(data: data)
    }

    func deleteImage(fileName: String?) {
        guard let fileName,
              let url = try? photosDirectory().appendingPathComponent(fileName),
              fileManager.fileExists(atPath: url.path) else {
            return
        }

        try? fileManager.removeItem(at: url)
    }

    private func photosDirectory() throws -> URL {
        let baseURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
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
}

