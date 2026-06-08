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
                privacyParagraph("You can keep your saved items, notes, locations, reminder settings, and photos only in SafeSpot's local store on this device, or enable synchronization through your private iCloud database. SafeSpot does not operate a backend server or receive your saved content.")
                privacyParagraph("When iCloud sync is enabled, text fields containing your saved-item details use CloudKit encrypted fields, and photos are stored as encrypted CloudKit assets.")
                privacyParagraph("Turning off iCloud sync moves the active SafeSpot data to a local-only store. Copies previously synchronized to iCloud are retained so they can be merged if you enable sync again.")
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
