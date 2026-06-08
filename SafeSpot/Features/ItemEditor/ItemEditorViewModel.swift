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
    var reminderFrequency: ReminderFrequency
    var customReminderDate: Date

    private let item: StoredItem?
    private let originalPhotoFileName: String?
    private let photoStorage: PhotoStorageService

    init(
        item: StoredItem? = nil,
        defaultReminderFrequency: ReminderFrequency = .none,
        photoStorage: PhotoStorageService = .shared
    ) {
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
        existingImage = photoStorage.image(from: item?.photoData)
            ?? photoStorage.loadLegacyImage(fileName: item?.photoFileName)
        reminderFrequency = item?.reminderFrequency ?? defaultReminderFrequency
        customReminderDate = Self.initialCustomReminderDate(for: item)
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

    var resolvedReminderDate: Date? {
        switch reminderFrequency {
        case .none:
            nil
        case .custom:
            customReminderDate
        default:
            ReminderDateCalculator.nextDate(frequency: reminderFrequency)
        }
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

    func save(in context: ModelContext) throws -> ItemEditorSaveResult {
        let now = Date.now
        var finalPhotoData = item?.photoData
        var finalPhotoFileName = originalPhotoFileName
        var notice: ItemEditorSaveNotice?
        let savedItem: StoredItem

        if let selectedImage {
            do {
                finalPhotoData = try photoStorage.makeSyncableData(from: selectedImage)
                finalPhotoFileName = nil
            } catch {
                notice = .photoCouldNotSave
            }
        } else if shouldRemovePhoto {
            finalPhotoData = nil
            finalPhotoFileName = nil
        } else if finalPhotoData == nil,
                  let legacyImage = photoStorage.loadLegacyImage(
                    fileName: originalPhotoFileName
                  ) {
            do {
                finalPhotoData = try photoStorage.makeSyncableData(
                    from: legacyImage
                )
                finalPhotoFileName = nil
            } catch {
                notice = .photoCouldNotSave
            }
        }

        if let item {
            applyValues(
                to: item,
                photoData: finalPhotoData,
                photoFileName: finalPhotoFileName
            )
            item.updatedAt = now
            savedItem = item
        } else {
            let newItem = StoredItem(
                name: trimmed(name),
                categoryRawValue: category.rawValue,
                place: trimmed(place),
                room: trimmed(room),
                container: trimmed(container),
                exactSpot: trimmed(exactSpot),
                privateNote: trimmed(privateNote),
                photoData: finalPhotoData,
                photoFileName: finalPhotoFileName,
                sensitivityRawValue: sensitivity.rawValue,
                createdAt: now,
                updatedAt: now,
                reminderDate: resolvedReminderDate,
                reminderFrequencyRawValue: reminderFrequency.rawValue
            )
            context.insert(newItem)
            savedItem = newItem
        }

        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }

        if originalPhotoFileName != finalPhotoFileName {
            photoStorage.deleteLegacyImage(fileName: originalPhotoFileName)
        }

        return ItemEditorSaveResult(item: savedItem, notice: notice)
    }

    private func applyValues(
        to item: StoredItem,
        photoData: Data?,
        photoFileName: String?
    ) {
        item.name = trimmed(name)
        item.categoryRawValue = category.rawValue
        item.place = trimmed(place)
        item.room = trimmed(room)
        item.container = trimmed(container)
        item.exactSpot = trimmed(exactSpot)
        item.privateNote = trimmed(privateNote)
        item.photoData = photoData
        item.photoFileName = photoFileName
        item.sensitivityRawValue = sensitivity.rawValue
        item.reminderDate = resolvedReminderDate
        item.reminderFrequencyRawValue = reminderFrequency.rawValue
    }

    private func trimmed(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func initialCustomReminderDate(for item: StoredItem?) -> Date {
        if let date = item?.reminderDate, date > .now {
            return date
        }

        return Calendar.current.date(byAdding: .day, value: 1, to: .now) ?? .now
    }
}

enum ItemEditorSaveNotice {
    case photoCouldNotSave
    case remindersDisabled
    case reminderCouldNotSchedule

    var title: String {
        switch self {
        case .photoCouldNotSave: "Could Not Save Photo"
        case .remindersDisabled: "Reminders Are Disabled"
        case .reminderCouldNotSchedule: "Could Not Schedule Reminder"
        }
    }

    var message: String {
        switch self {
        case .photoCouldNotSave:
            "Your item was saved without the new photo."
        case .remindersDisabled:
            "Your item was saved. You can enable notifications for this app in iOS Settings."
        case .reminderCouldNotSchedule:
            "Your item was saved, but the reminder could not be scheduled. Please try again."
        }
    }
}

struct ItemEditorSaveResult {
    let item: StoredItem
    let notice: ItemEditorSaveNotice?
}
