import SwiftUI

struct SearchField: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppColors.textSecondary)

            TextField("Search passport, keys, drawer...", text: $text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .foregroundStyle(AppColors.textPrimary)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(AppColors.textTertiary)
                }
                .accessibilityLabel("Clear search")
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.elevatedSurface.opacity(0.82))
        .clipShape(RoundedRectangle(cornerRadius: AppCorners.field, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: AppCorners.field, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        }
    }
}

