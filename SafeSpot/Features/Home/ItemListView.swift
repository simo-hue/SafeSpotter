import SwiftUI

struct ItemListView: View {
    let items: [StoredItem]
    let isDiscreetModeEnabled: Bool

    var body: some View {
        LazyVStack(spacing: AppSpacing.md) {
            ForEach(items) { item in
                NavigationLink {
                    ItemDetailView(item: item)
                } label: {
                    ItemCardView(
                        item: item,
                        isDiscreetModeEnabled: isDiscreetModeEnabled
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}

