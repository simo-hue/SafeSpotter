#if DEBUG
import Foundation

enum SampleData {
    static let items = [
        StoredItem(
            name: "Passport",
            categoryRawValue: ItemCategory.documents.rawValue,
            place: "Home",
            room: "Bedroom",
            container: "Wardrobe",
            exactSpot: "Blue box on the top shelf"
        ),
        StoredItem(
            name: "Spare Keys",
            categoryRawValue: ItemCategory.keys.rawValue,
            place: "Home",
            room: "Entryway",
            container: "Console drawer"
        ),
        StoredItem(
            name: "Emergency Cash",
            categoryRawValue: ItemCategory.money.rawValue,
            place: "Home",
            room: "Study",
            sensitivityRawValue: SensitivityLevel.highlyPrivate.rawValue
        ),
        StoredItem(
            name: "USB Backup Drive",
            categoryRawValue: ItemCategory.electronics.rawValue,
            place: "Office",
            room: "Study",
            container: "Desk drawer"
        ),
        StoredItem(
            name: "Warranty Documents",
            categoryRawValue: ItemCategory.documents.rawValue
        )
    ]
}
#endif

