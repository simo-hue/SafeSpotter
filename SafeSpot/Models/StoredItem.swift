import Foundation
import SwiftData

@Model
final class StoredItem {
    var id: UUID = UUID()
    var modelVersion: Int = 1
    @Attribute(.allowsCloudEncryption) var name: String = ""
    @Attribute(.allowsCloudEncryption) var categoryRawValue: String = ItemCategory.other.rawValue
    @Attribute(.allowsCloudEncryption) var place: String = ""
    @Attribute(.allowsCloudEncryption) var room: String = ""
    @Attribute(.allowsCloudEncryption) var container: String = ""
    @Attribute(.allowsCloudEncryption) var exactSpot: String = ""
    @Attribute(.allowsCloudEncryption) var privateNote: String = ""
    @Attribute(.externalStorage) var photoData: Data?
    // Retained temporarily so existing on-device photos can migrate into photoData.
    var photoFileName: String?
    @Attribute(.allowsCloudEncryption) var sensitivityRawValue: String = SensitivityLevel.normal.rawValue
    @Attribute(.allowsCloudEncryption) var createdAt: Date = Date.now
    @Attribute(.allowsCloudEncryption) var updatedAt: Date = Date.now
    @Attribute(.allowsCloudEncryption) var lastCheckedAt: Date?
    @Attribute(.allowsCloudEncryption) var reminderDate: Date?
    @Attribute(.allowsCloudEncryption) var reminderFrequencyRawValue: String = ReminderFrequency.none.rawValue
    @Attribute(.allowsCloudEncryption) var isArchived: Bool = false

    init(
        id: UUID = UUID(),
        modelVersion: Int = 1,
        name: String,
        categoryRawValue: String = ItemCategory.other.rawValue,
        place: String = "",
        room: String = "",
        container: String = "",
        exactSpot: String = "",
        privateNote: String = "",
        photoData: Data? = nil,
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
        self.modelVersion = modelVersion
        self.name = name
        self.categoryRawValue = categoryRawValue
        self.place = place
        self.room = room
        self.container = container
        self.exactSpot = exactSpot
        self.privateNote = privateNote
        self.photoData = photoData
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
