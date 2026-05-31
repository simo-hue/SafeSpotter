import SwiftUI

struct SecondaryButton: View {
    let title: String
    var systemImage: String?
    var role: ButtonRole?
    let action: () -> Void

    var body: some View {
        Button(role: role) {
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
            .padding(.vertical, 15)
            .foregroundStyle(role == .destructive ? AppColors.danger : AppColors.textPrimary)
            .background(AppColors.elevatedSurface.opacity(0.78))
            .clipShape(RoundedRectangle(cornerRadius: AppCorners.button, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: AppCorners.button, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            }
        }
    }
}

