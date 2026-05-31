import SwiftData
import SwiftUI

struct HomeView: View {
    @Query(sort: \StoredItem.updatedAt, order: .reverse) private var items: [StoredItem]
    @AppStorage(AppSettingsKey.isDiscreetModeEnabled) private var isDiscreetModeEnabled = false
    @AppStorage(AppSettingsKey.sortOption) private var sortOptionRawValue = ItemSortOption.recentlyUpdated.rawValue
    @State private var searchText = ""
    @State private var selectedCategory: ItemCategory?
    @State private var isShowingAddItem = false
    @State private var isShowingSettings = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.lg) {
                        HomeHeaderView(hasItems: !visibleItems.isEmpty)
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.top, AppSpacing.md)

                        SearchField(text: $searchText)
                            .padding(.horizontal, AppSpacing.lg)

                        CategoryFilterBar(selectedCategory: $selectedCategory)

                        sortRow
                            .padding(.horizontal, AppSpacing.lg)

                        content
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.bottom, 92)
                    }
                }

                if !visibleItems.isEmpty {
                    addButton
                        .padding(AppSpacing.lg)
                }
            }
            .appScreenBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityLabel("Settings")
                }
            }
            .sheet(isPresented: $isShowingAddItem) {
                AddItemView()
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
            }
        }
    }

    private var visibleItems: [StoredItem] {
        items.filter { !$0.isArchived }
    }

    private var filteredItems: [StoredItem] {
        StoredItemListFilter.filterAndSort(
            items,
            searchText: searchText,
            selectedCategory: selectedCategory,
            sortOption: sortOption
        )
    }

    private var sortOption: ItemSortOption {
        get { ItemSortOption(rawValue: sortOptionRawValue) ?? .recentlyUpdated }
        nonmutating set { sortOptionRawValue = newValue.rawValue }
    }

    @ViewBuilder
    private var content: some View {
        if visibleItems.isEmpty {
            EmptyStateView(
                title: "Nothing saved yet",
                message: "Add your first important item and SafeSpot will remember where you put it.",
                symbolName: "archivebox",
                buttonTitle: "Add First Item"
            ) {
                isShowingAddItem = true
            }
        } else if filteredItems.isEmpty {
            EmptyStateView(
                title: "No matches found",
                message: "Try a different search or category.",
                symbolName: "magnifyingglass"
            )
        } else {
            ItemListView(
                items: filteredItems,
                isDiscreetModeEnabled: isDiscreetModeEnabled
            )
        }
    }

    private var sortRow: some View {
        HStack {
            Text("\(filteredItems.count) \(filteredItems.count == 1 ? "item" : "items")")
                .font(.caption)
                .foregroundStyle(AppColors.textSecondary)

            Spacer()

            Menu {
                Picker("Sort items", selection: Binding(
                    get: { sortOption },
                    set: { sortOption = $0 }
                )) {
                    ForEach(ItemSortOption.allCases) { option in
                        Text(option.title)
                            .tag(option)
                    }
                }
            } label: {
                Label(sortOption.title, systemImage: "arrow.up.arrow.down")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
    }

    private var addButton: some View {
        Button {
            HapticService.lightImpact()
            isShowingAddItem = true
        } label: {
            Image(systemName: "plus")
                .font(.title3.bold())
                .foregroundStyle(.white)
                .frame(width: 60, height: 60)
                .background(AppColors.primary)
                .clipShape(Circle())
                .shadow(color: AppColors.primary.opacity(0.38), radius: 18, y: 8)
        }
        .accessibilityLabel("Add new item")
    }
}

#Preview {
    HomeView()
        .modelContainer(for: StoredItem.self, inMemory: true)
}
