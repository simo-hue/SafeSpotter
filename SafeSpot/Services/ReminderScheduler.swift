import Foundation
import UserNotifications

final class ReminderScheduler {
    static let shared = ReminderScheduler()

    private let notificationCenter: UNUserNotificationCenter

    init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
    }

    func updateReminder(
        for item: StoredItem,
        requestAuthorizationIfNeeded: Bool = true
    ) async -> ReminderScheduleResult {
        cancelReminder(for: item.id)

        guard let date = item.reminderDate, date > .now else {
            return .cancelled
        }

        guard await hasPermission(
            requestAuthorizationIfNeeded: requestAuthorizationIfNeeded
        ) else {
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

    func reconcileReminders(for items: [StoredItem]) async {
        let desiredItems = items.filter {
            !$0.isArchived && ($0.reminderDate.map { $0 > .now } ?? false)
        }
        let desiredIdentifiers = Set(
            desiredItems.map { notificationIdentifier(for: $0.id) }
        )
        let pendingRequests = await notificationCenter.pendingNotificationRequests()
        let staleIdentifiers = pendingRequests
            .map(\.identifier)
            .filter {
                $0.hasPrefix("safespot.item-reminder.")
                    && !desiredIdentifiers.contains($0)
            }

        if !staleIdentifiers.isEmpty {
            notificationCenter.removePendingNotificationRequests(
                withIdentifiers: staleIdentifiers
            )
        }

        guard await hasPermission(requestAuthorizationIfNeeded: false) else {
            return
        }

        for item in desiredItems {
            _ = await updateReminder(
                for: item,
                requestAuthorizationIfNeeded: false
            )
        }
    }

    private func hasPermission(
        requestAuthorizationIfNeeded: Bool
    ) async -> Bool {
        let settings = await notificationCenter.notificationSettings()

        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        case .denied:
            return false
        case .notDetermined:
            guard requestAuthorizationIfNeeded else {
                return false
            }

            return (try? await notificationCenter.requestAuthorization(
                options: [.alert, .sound, .badge]
            )) ?? false
        @unknown default:
            return false
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
