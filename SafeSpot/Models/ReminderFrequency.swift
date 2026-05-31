enum ReminderFrequency: String, CaseIterable, Identifiable {
    case none
    case oneMonth
    case threeMonths
    case sixMonths
    case oneYear
    case custom

    var id: String { rawValue }

    var title: String {
        switch self {
        case .none: "No Reminder"
        case .oneMonth: "Every Month"
        case .threeMonths: "Every 3 Months"
        case .sixMonths: "Every 6 Months"
        case .oneYear: "Every Year"
        case .custom: "Custom Date"
        }
    }
}

