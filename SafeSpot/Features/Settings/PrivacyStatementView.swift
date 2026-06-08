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

                privacyParagraph("SafeSpot is designed to work offline and does not require a SafeSpot account.")
                privacyParagraph("Your saved items, notes, locations, reminder settings, and photos are stored on this device and synchronized through your private iCloud database when iCloud is available. SafeSpot does not operate a backend server or receive your saved content.")
                privacyParagraph("Text fields containing your saved-item details use CloudKit encrypted fields, and photos are stored as encrypted CloudKit assets.")
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
