import SwiftUI

struct ItemCardView: View {
    let item: StoredItem
    let isDiscreetModeEnabled: Bool

    private var isMasked: Bool {
        isDiscreetModeEnabled && item.isSensitive
    }

    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            Image(systemName: isMasked ? "lock.fill" : item.category.symbolName)
                .font(.title3)
                .foregroundStyle(isMasked ? AppColors.primary : AppColors.secondary)
                .frame(width: 48, height: 48)
                .background(AppColors.elevatedSurface)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(isMasked ? "Private Item" : item.name)
                    .font(.headline)
                    .foregroundStyle(AppColors.textPrimary)
                    .lineLimit(2)

                Text(isMasked ? "Location hidden" : item.category.title)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.textSecondary)

                Text(isMasked ? "Tap to unlock details" : locationText)
                    .font(.caption)
                    .foregroundStyle(AppColors.textSecondary)
                    .lineLimit(2)

                Text(isMasked ? "Sensitive details masked" : "Last checked: \(lastCheckedText)")
                    .font(.caption2)
                    .foregroundStyle(AppColors.textTertiary)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(AppColors.textTertiary)
                .padding(.top, AppSpacing.sm)
                .accessibilityHidden(true)
        }
        .padding(AppSpacing.md)
        .glassCard()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
        .accessibilityHint("Opens item details")
    }

    private var locationText: String {
        item.hasLocation ? item.locationSummary : "No location details saved yet."
    }

    private var lastCheckedText: String {
        item.lastCheckedAt.map(DateFormatters.display) ?? "Never"
    }

    private var accessibilityText: String {
        if isMasked {
            return "Private item. Details hidden in Discreet Mode."
        }

        return "\(item.name), \(item.category.title), \(locationText), last checked \(lastCheckedText)."
    }
}

