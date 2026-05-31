import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    let symbolName: String
    var buttonTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: symbolName)
                .font(.system(size: 44))
                .foregroundStyle(AppColors.secondary)
                .accessibilityHidden(true)

            Text(title)
                .font(.title3.bold())
                .foregroundStyle(AppColors.textPrimary)

            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(AppColors.textSecondary)

            if let buttonTitle, let action {
                PrimaryButton(title: buttonTitle, systemImage: "plus", action: action)
                    .padding(.top, AppSpacing.sm)
            }
        }
        .padding(AppSpacing.lg)
        .glassCard()
    }
}

