import SwiftUI

struct OnboardingView: View {
    @AppStorage(AppSettingsKey.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @AppStorage(AppSettingsKey.isAppLockEnabled) private var isAppLockEnabled = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var selectedPage = 0
    @State private var isShowingProtectionChoice = false
    @State private var isShowingProtectionError = false

    private let pages = OnboardingPage.all

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedPage) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    onboardingPage(page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .animation(reduceMotion ? nil : .easeInOut, value: selectedPage)

            Button {
                if selectedPage == pages.count - 1 {
                    isShowingProtectionChoice = true
                } else {
                    selectedPage += 1
                }
            } label: {
                Text(selectedPage == pages.count - 1 ? "Get Started" : "Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 17)
                    .background(AppColors.primary)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: AppCorners.button, style: .continuous))
            }
            .padding(AppSpacing.lg)
            .accessibilityHint(selectedPage == pages.count - 1 ? "Opens your private vault" : "Shows the next introduction screen")
        }
        .appScreenBackground()
        .confirmationDialog(
            "Protect your saved items with Face ID?",
            isPresented: $isShowingProtectionChoice,
            titleVisibility: .visible
        ) {
            Button("Enable Protection") {
                enableProtection()
            }

            Button("Maybe Later") {
                hasCompletedOnboarding = true
            }
        } message: {
            Text("You can also enable Face ID or device passcode protection later in Settings.")
        }
        .alert("Could Not Enable Protection", isPresented: $isShowingProtectionError) {
            Button("Continue Without Protection") {
                hasCompletedOnboarding = true
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Set up a device passcode, Face ID, or Touch ID in iOS Settings, then try again.")
        }
    }

    private func onboardingPage(_ page: OnboardingPage) -> some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()

            Image(systemName: page.symbolName)
                .font(.system(size: 72))
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.secondary, AppColors.primary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .accessibilityHidden(true)

            Text(page.title)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(AppColors.textPrimary)

            Text(page.body)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(AppColors.textSecondary)
                .padding(.horizontal, AppSpacing.lg)

            Spacer()
        }
        .padding(AppSpacing.md)
    }

    private func enableProtection() {
        if AuthenticationService.shared.canAuthenticate() {
            isAppLockEnabled = true
            hasCompletedOnboarding = true
        } else {
            isShowingProtectionError = true
        }
    }
}

private struct OnboardingPage {
    let title: String
    let body: String
    let symbolName: String

    static let all = [
        OnboardingPage(
            title: "Remember where you keep what matters",
            body: "Save the exact spot of important things like passports, spare keys, documents, and valuables.",
            symbolName: "archivebox.fill"
        ),
        OnboardingPage(
            title: "Private by design",
            body: "No account. No cloud. Your saved items stay on this iPhone.",
            symbolName: "lock.shield.fill"
        ),
        OnboardingPage(
            title: "Find things fast",
            body: "Search by item, room, drawer, box, or note whenever you need to find something.",
            symbolName: "magnifyingglass"
        )
    ]
}

#Preview {
    OnboardingView()
}
