import Foundation

enum ReminderDateCalculator {
    static func nextDate(
        from date: Date = .now,
        frequency: ReminderFrequency,
        calendar: Calendar = .current
    ) -> Date? {
        switch frequency {
        case .none, .custom:
            nil
        case .oneMonth:
            calendar.date(byAdding: .month, value: 1, to: date)
        case .threeMonths:
            calendar.date(byAdding: .month, value: 3, to: date)
        case .sixMonths:
            calendar.date(byAdding: .month, value: 6, to: date)
        case .oneYear:
            calendar.date(byAdding: .year, value: 1, to: date)
        }
    }
}

