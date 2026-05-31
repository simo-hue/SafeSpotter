import XCTest
@testable import SafeSpot

final class StoredItemListFilterTests: XCTestCase {
    func testSearchMatchesNotesAndExcludesArchivedItems() {
        let matching = StoredItem(name: "Passport", privateNote: "Blue folder")
        let archived = StoredItem(name: "Old Passport", privateNote: "Blue folder", isArchived: true)
        let other = StoredItem(name: "Keys", privateNote: "Kitchen drawer")

        let results = StoredItemListFilter.filterAndSort(
            [matching, archived, other],
            searchText: "blue folder",
            selectedCategory: nil,
            sortOption: .recentlyUpdated
        )

        XCTAssertEqual(results.map(\.name), ["Passport"])
    }

    func testCategoryFilterAndNameSort() {
        let travel = StoredItem(name: "Passport", categoryRawValue: ItemCategory.travel.rawValue)
        let keysB = StoredItem(name: "Spare Keys", categoryRawValue: ItemCategory.keys.rawValue)
        let keysA = StoredItem(name: "Apartment Keys", categoryRawValue: ItemCategory.keys.rawValue)

        let results = StoredItemListFilter.filterAndSort(
            [travel, keysB, keysA],
            searchText: "",
            selectedCategory: .keys,
            sortOption: .nameAscending
        )

        XCTAssertEqual(results.map(\.name), ["Apartment Keys", "Spare Keys"])
    }
}

