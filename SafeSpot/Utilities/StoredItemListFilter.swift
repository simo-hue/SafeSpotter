import Foundation

enum StoredItemListFilter {
    static func filterAndSort(
        _ items: [StoredItem],
        searchText: String,
        selectedCategory: ItemCategory?,
        sortOption: ItemSortOption
    ) -> [StoredItem] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let filtered = items.filter { item in
            let matchesSearch = query.isEmpty || item.searchableText.contains(query)
            let matchesCategory = selectedCategory == nil || item.category == selectedCategory
            return !item.isArchived && matchesSearch && matchesCategory
        }

        switch sortOption {
        case .recentlyUpdated:
            return filtered.sorted { $0.updatedAt > $1.updatedAt }
        case .nameAscending:
            return filtered.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        case .lastChecked:
            return filtered.sorted {
                ($0.lastCheckedAt ?? .distantPast) > ($1.lastCheckedAt ?? .distantPast)
            }
        case .category:
            return filtered.sorted { $0.category.title < $1.category.title }
        }
    }
}

