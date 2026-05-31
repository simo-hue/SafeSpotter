import SwiftUI

struct CategoryChip: View {
    let title: String
    var symbolName: String?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xs) {
                if let symbolName {
                    Image(systemName: symbolName)
                        .font(.caption)
                }

                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(isSelected ? Color.white : AppColors.textSecondary)
            .padding(.horizontal, 13)
            .padding(.vertical, 9)
            .background(isSelected ? AppColors.primary : AppColors.elevatedSurface.opacity(0.74))
            .clipShape(Capsule())
        }
    }
}

