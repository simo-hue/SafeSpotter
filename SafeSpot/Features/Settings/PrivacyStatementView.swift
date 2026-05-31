import SwiftUI

struct PrivacyStatementView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(AppColors.secondary)
                    .accessibilityHidden(true)

                Text("Privacy Statement")
                    .font(.largeTitle.bold())
                    .foregroundStyle(AppColors.textPrimary)

                privacyParagraph("This app is designed to work locally on your iPhone.")
                privacyParagraph("Your saved items, notes, locations, and photos are stored in the app's local container on this device. The app does not require an account, does not use cloud sync, and does not send your saved content to a server.")
                privacyParagraph("If you enable Face ID or Passcode protection, the app uses Apple's local authentication system to help protect access. The app never receives your biometric data.")
                privacyParagraph("Local reminders are scheduled on this device using iOS notifications. Notification text is intentionally discreet and does not include item names.")
                privacyParagraph("The app does not include advertising SDKs, tracking SDKs, or remote analytics in this version.")
            }
            .padding(AppSpacing.lg)
        }
        .appScreenBackground()
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func privacyParagraph(_ text: String) -> some View {
        Text(text)
            .font(.body)
            .foregroundStyle(AppColors.textSecondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}
