import XCTest
@testable import SafeSpot

final class StoredItemTests: XCTestCase {
    func testLocationSummarySkipsBlankComponents() {
        let item = StoredItem(
            name: "Passport",
            categoryRawValue: ItemCategory.documents.rawValue,
            place: "Home",
            room: " ",
            container: "Wardrobe",
            exactSpot: "Blue box"
        )

        XCTAssertEqual(item.locationSummary, "Home › Wardrobe › Blue box")
        XCTAssertTrue(item.hasLocation)
    }

    func testSearchableTextIncludesNoteAndLocation() {
        let item = StoredItem(
            name: "USB Drive",
            categoryRawValue: ItemCategory.electronics.rawValue,
            room: "Study",
            privateNote: "Backup from April"
        )

        XCTAssertTrue(item.searchableText.contains("study"))
        XCTAssertTrue(item.searchableText.contains("backup from april"))
    }

    func testSensitiveItemsAreMarkedForDiscreetMode() {
        let item = StoredItem(name: "Cash", sensitivityRawValue: SensitivityLevel.privateItem.rawValue)

        XCTAssertTrue(item.isSensitive)
    }
}

