import SwiftUI

struct AppScreenBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                colors: [
                    AppColors.background,
                    Color(red: 0.07, green: 0.08, blue: 0.16),
                    Color(red: 0.12, green: 0.09, blue: 0.18)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            content
        }
    }
}

struct GlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(AppColors.surface.opacity(0.86))
            .clipShape(RoundedRectangle(cornerRadius: AppCorners.card, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: AppCorners.card, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            }
    }
}

extension View {
    func appScreenBackground() -> some View {
        modifier(AppScreenBackground())
    }

    func glassCard() -> some View {
        modifier(GlassCardModifier())
    }
}

