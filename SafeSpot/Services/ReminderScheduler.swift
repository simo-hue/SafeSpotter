import Foundation
import UserNotifications

final class ReminderScheduler {
    static let shared = ReminderScheduler()

    private let notificationCenter: UNUserNotificationCenter

    init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
    }

    func updateReminder(for item: StoredItem) async -> ReminderScheduleResult {
        cancelReminder(for: item.id)

        guard let date = item.reminderDate, date > .now else {
            return .cancelled
        }

        guard await requestPermissionIfNeeded() else {
            return .permissionDenied
        }

        let content = UNMutableNotificationContent()
        content.title = "SafeSpot"
        content.body = "Time to check a saved item."
        content.sound = .default

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(
            identifier: notificationIdentifier(for: item.id),
            content: content,
            trigger: trigger
        )

        do {
            try await notificationCenter.add(request)
            return .scheduled
        } catch {
            return .failed
        }
    }

    func cancelReminder(for itemID: UUID) {
        notificationCenter.removePendingNotificationRequests(
            withIdentifiers: [notificationIdentifier(for: itemID)]
        )
    }

    private func requestPermissionIfNeeded() async -> Bool {
        let settings = await notificationCenter.notificationSettings()

        return switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            true
        case .denied:
            false
        case .notDetermined:
            (try? await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
        @unknown default:
            false
        }
    }

    private func notificationIdentifier(for itemID: UUID) -> String {
        "safespot.item-reminder.\(itemID.uuidString)"
    }
}

enum ReminderScheduleResult {
    case scheduled
    case cancelled
    case permissionDenied
    case failed

    var notice: ItemEditorSaveNotice? {
        switch self {
        case .scheduled, .cancelled:
            nil
        case .permissionDenied:
            .remindersDisabled
        case .failed:
            .reminderCouldNotSchedule
        }
    }
}
