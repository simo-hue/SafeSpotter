enum ItemSortOption: String, CaseIterable, Identifiable {
    case recentlyUpdated
    case nameAscending
    case lastChecked
    case category

    var id: String { rawValue }

    var title: String {
        switch self {
        case .recentlyUpdated: "Recently Updated"
        case .nameAscending: "Name"
        case .lastChecked: "Last Checked"
        case .category: "Category"
        }
    }
}

