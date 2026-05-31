import UIKit

enum HapticService {
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func warning() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    static func lightImpact() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

