import Foundation
import SwiftData

@Model
final class StoredItem {
    var id: UUID
    var name: String
    var categoryRawValue: String
    var place: String
    var room: String
    var container: String
    var exactSpot: String
    var privateNote: String
    var photoFileName: String?
    var sensitivityRawValue: String
    var createdAt: Date
    var updatedAt: Date
    var lastCheckedAt: Date?
    var reminderDate: Date?
    var reminderFrequencyRawValue: String
    var isArchived: Bool

    init(
        id: UUID = UUID(),
        name: String,
        categoryRawValue: String = ItemCategory.other.rawValue,
        place: String = "",
        room: String = "",
        container: String = "",
        exactSpot: String = "",
        privateNote: String = "",
        photoFileName: String? = nil,
        sensitivityRawValue: String = SensitivityLevel.normal.rawValue,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        lastCheckedAt: Date? = nil,
        reminderDate: Date? = nil,
        reminderFrequencyRawValue: String = ReminderFrequency.none.rawValue,
        isArchived: Bool = false
    ) {
        self.id = id
        self.name = name
        self.categoryRawValue = categoryRawValue
        self.place = place
        self.room = room
        self.container = container
        self.exactSpot = exactSpot
        self.privateNote = privateNote
        self.photoFileName = photoFileName
        self.sensitivityRawValue = sensitivityRawValue
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastCheckedAt = lastCheckedAt
        self.reminderDate = reminderDate
        self.reminderFrequencyRawValue = reminderFrequencyRawValue
        self.isArchived = isArchived
    }
}

