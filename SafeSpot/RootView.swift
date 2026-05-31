import SwiftUI

struct RootView: View {
    @AppStorage(AppSettingsKey.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @AppStorage(AppSettingsKey.isAppLockEnabled) private var isAppLockEnabled = false
    @Environment(\.scenePhase) private var scenePhase
    @State private var isAuthenticated = false

    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView()
            } else if isAppLockEnabled && !isAuthenticated {
                LockView(isAuthenticated: $isAuthenticated)
            } else {
                HomeView()
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: scenePhase) { _, newPhase in
            if isAppLockEnabled && (newPhase == .background || newPhase == .inactive) {
                isAuthenticated = false
            }
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: StoredItem.self, inMemory: true)
}
