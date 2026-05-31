import SwiftUI

struct LockView: View {
    @Binding var isAuthenticated: Bool
    @State private var isAuthenticating = false
    @State private var isShowingAuthenticationError = false

    var body: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()

            Image(systemName: "lock.shield.fill")
                .font(.system(size: 72))
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.secondary, AppColors.primary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .accessibilityHidden(true)

            Text("Vault Locked")
                .font(.title.bold())
                .foregroundStyle(AppColors.textPrimary)

            Text("Unlock to view your saved items.")
                .font(.body)
                .foregroundStyle(AppColors.textSecondary)

            PrimaryButton(
                title: isAuthenticating ? "Unlocking..." : "Unlock",
                systemImage: "lock.open.fill",
                isDisabled: isAuthenticating
            ) {
                Task {
                    await authenticate()
                }
            }
            .padding(.top, AppSpacing.sm)

            Spacer()
        }
        .padding(AppSpacing.lg)
        .appScreenBackground()
        .task {
            await authenticate()
        }
        .alert("Could Not Unlock", isPresented: $isShowingAuthenticationError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please try again.")
        }
    }

    private func authenticate() async {
        guard !isAuthenticating else { return }

        isAuthenticating = true
        let didAuthenticate = await AuthenticationService.shared.authenticate()
        isAuthenticating = false

        if didAuthenticate {
            isAuthenticated = true
        } else {
            isShowingAuthenticationError = true
        }
    }
}

#Preview {
    LockView(isAuthenticated: .constant(false))
}
