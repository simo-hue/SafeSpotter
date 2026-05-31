import SwiftUI

struct HomeHeaderView: View {
    let hasItems: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(hasItems ? "What are you looking for?" : "Your safe spots, remembered.")
                .font(.largeTitle.bold())
                .foregroundStyle(AppColors.textPrimary)

            Text("Find important things you stored away.")
                .font(.body)
                .foregroundStyle(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
