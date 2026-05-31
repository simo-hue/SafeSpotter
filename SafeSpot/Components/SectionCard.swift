import SwiftUI

struct SectionCard<Content: View>: View {
    let title: String
    var systemImage: String?
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack(spacing: AppSpacing.sm) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .foregroundStyle(AppColors.secondary)
                }

                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppColors.textPrimary)
            }

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppSpacing.md)
        .glassCard()
    }
}

