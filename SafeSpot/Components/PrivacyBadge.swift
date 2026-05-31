import SwiftUI

struct PrivacyBadge: View {
    let sensitivity: SensitivityLevel

    var body: some View {
        Label(sensitivity.title, systemImage: sensitivity == .normal ? "eye.fill" : "lock.fill")
            .font(.caption.weight(.semibold))
            .foregroundStyle(sensitivity == .normal ? AppColors.secondary : AppColors.primary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(AppColors.elevatedSurface.opacity(0.9))
            .clipShape(Capsule())
    }
}

