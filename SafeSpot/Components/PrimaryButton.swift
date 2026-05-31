import SwiftUI

struct PrimaryButton: View {
    let title: String
    var systemImage: String?
    var isDisabled = false
    let action: () -> Void

    var body: some View {
        Button {
            HapticService.lightImpact()
            action()
        } label: {
            HStack(spacing: AppSpacing.sm) {
                if let systemImage {
                    Image(systemName: systemImage)
                }

                Text(title)
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .foregroundStyle(.white)
            .background {
                LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.opacity(0.76)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: AppCorners.button, style: .continuous))
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.45 : 1)
    }
}

