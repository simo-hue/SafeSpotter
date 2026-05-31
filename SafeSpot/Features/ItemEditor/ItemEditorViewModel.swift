import Foundation
import Observation
import SwiftData
import UIKit

@MainActor
@Observable
final class ItemEditorViewModel {
    var name: String
    var category: ItemCategory
    var place: String
    var room: String
    var container: String
    var exactSpot: String
    var privateNote: String
    var sensitivity: SensitivityLevel
    var selectedImage: UIImage?
    var existingImage: UIImage?
    var shouldRemovePhoto = false

    private let item: StoredItem?
    private let originalPhotoFileName: String?
    private let photoStorage: PhotoStorageService

    init(item: StoredItem? = nil, photoStorage: PhotoStorageService = .shared) {
        self.item = item
        self.photoStorage = photoStorage
        originalPhotoFileName = item?.photoFileName
        name = item?.name ?? ""
        category = item?.category ?? .other
        place = item?.place ?? ""
        room = item?.room ?? ""
        container = item?.container ?? ""
        exactSpot = item?.exactSpot ?? ""
        privateNote = item?.privateNote ?? ""
        sensitivity = item?.sensitivity ?? .normal
        existingImage = photoStorage.loadImage(fileName: item?.photoFileName)
    }

    var canSave: Bool {
        !trimmed(name).isEmpty
    }

    var isEditing: Bool {
        item != nil
    }

    var displayedImage: UIImage? {
        selectedImage ?? existingImage
    }

    func selectPhoto(_ image: UIImage) {
        selectedImage = image
        shouldRemovePhoto = false
    }

    func removePhoto() {
        selectedImage = nil
        existingImage = nil
        shouldRemovePhoto = true
    }

    func save(in context: ModelContext) throws -> ItemEditorSaveNotice? {
        let now = Date.now
        var finalPhotoFileName = originalPhotoFileName
        var newPhotoFileName: String?
        var notice: ItemEditorSaveNotice?

        if let selectedImage {
            do {
                let savedFileName = try photoStorage.saveImage(selectedImage)
                newPhotoFileName = savedFileName
                finalPhotoFileName = savedFileName
            } catch {
                notice = .photoCouldNotSave
            }
        } else if shouldRemovePhoto {
            finalPhotoFileName = nil
        }

        if let item {
            applyValues(to: item, photoFileName: finalPhotoFileName)
            item.updatedAt = now
        } else {
            let newItem = StoredItem(
                name: trimmed(name),
                categoryRawValue: category.rawValue,
                place: trimmed(place),
                room: trimmed(room),
                container: trimmed(container),
                exactSpot: trimmed(exactSpot),
                privateNote: trimmed(privateNote),
                photoFileName: finalPhotoFileName,
                sensitivityRawValue: sensitivity.rawValue,
                createdAt: now,
                updatedAt: now
            )
            context.insert(newItem)
        }

        do {
            try context.save()
        } catch {
            photoStorage.deleteImage(fileName: newPhotoFileName)
            throw error
        }

        if originalPhotoFileName != finalPhotoFileName {
            photoStorage.deleteImage(fileName: originalPhotoFileName)
        }

        return notice
    }

    private func applyValues(to item: StoredItem, photoFileName: String?) {
        item.name = trimmed(name)
        item.categoryRawValue = category.rawValue
        item.place = trimmed(place)
        item.room = trimmed(room)
        item.container = trimmed(container)
        item.exactSpot = trimmed(exactSpot)
        item.privateNote = trimmed(privateNote)
        item.photoFileName = photoFileName
        item.sensitivityRawValue = sensitivity.rawValue
    }

    private func trimmed(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

enum ItemEditorSaveNotice {
    case photoCouldNotSave

    var title: String {
        "Could Not Save Photo"
    }

    var message: String {
        "Your item was saved without the new photo."
    }
}
