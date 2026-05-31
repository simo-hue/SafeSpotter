import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.lg) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(AppColors.secondary)
                    .accessibilityHidden(true)

                Text("Your safe spots, remembered.")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                    .foregroundStyle(AppColors.textPrimary)

                Text("Find important things you stored away.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(AppColors.textSecondary)
            }
            .padding(AppSpacing.xl)
            .glassCard()
            .padding(AppSpacing.lg)
            .navigationTitle("SafeSpot")
            .appScreenBackground()
        }
    }
}

#Preview {
    HomeView()
}

