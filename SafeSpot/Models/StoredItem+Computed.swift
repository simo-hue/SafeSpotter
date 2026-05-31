import Foundation

extension StoredItem {
    var category: ItemCategory {
        ItemCategory(rawValue: categoryRawValue) ?? .other
    }

    var sensitivity: SensitivityLevel {
        SensitivityLevel(rawValue: sensitivityRawValue) ?? .normal
    }

    var reminderFrequency: ReminderFrequency {
        ReminderFrequency(rawValue: reminderFrequencyRawValue) ?? .none
    }

    var locationSummary: String {
        [place, room, container, exactSpot]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " › ")
    }

    var searchableText: String {
        [name, category.title, place, room, container, exactSpot, privateNote]
            .joined(separator: " ")
            .lowercased()
    }

    var hasLocation: Bool {
        !locationSummary.isEmpty
    }

    var isSensitive: Bool {
        sensitivity.shouldMaskInDiscreetMode
    }
}

