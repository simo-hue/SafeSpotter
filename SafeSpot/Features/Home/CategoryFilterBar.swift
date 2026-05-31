import SwiftUI

struct CategoryFilterBar: View {
    @Binding var selectedCategory: ItemCategory?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                CategoryChip(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }

                ForEach(ItemCategory.allCases) { category in
                    CategoryChip(
                        title: category.title,
                        symbolName: category.symbolName,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal, AppSpacing.lg)
        }
    }
}

