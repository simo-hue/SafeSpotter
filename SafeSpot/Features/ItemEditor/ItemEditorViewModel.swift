import Foundation
import Observation
import SwiftData

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

    private let item: StoredItem?

    init(item: StoredItem? = nil) {
        self.item = item
        name = item?.name ?? ""
        category = item?.category ?? .other
        place = item?.place ?? ""
        room = item?.room ?? ""
        container = item?.container ?? ""
        exactSpot = item?.exactSpot ?? ""
        privateNote = item?.privateNote ?? ""
        sensitivity = item?.sensitivity ?? .normal
    }

    var canSave: Bool {
        !trimmed(name).isEmpty
    }

    var isEditing: Bool {
        item != nil
    }

    func save(in context: ModelContext) throws {
        let now = Date.now

        if let item {
            applyValues(to: item)
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
                sensitivityRawValue: sensitivity.rawValue,
                createdAt: now,
                updatedAt: now
            )
            context.insert(newItem)
        }

        try context.save()
    }

    private func applyValues(to item: StoredItem) {
        item.name = trimmed(name)
        item.categoryRawValue = category.rawValue
        item.place = trimmed(place)
        item.room = trimmed(room)
        item.container = trimmed(container)
        item.exactSpot = trimmed(exactSpot)
        item.privateNote = trimmed(privateNote)
        item.sensitivityRawValue = sensitivity.rawValue
    }

    private func trimmed(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

