import Foundation

enum ItemCategory: String, CaseIterable, Identifiable {
    case documents
    case keys
    case money
    case jewelry
    case electronics
    case travel
    case health
    case home
    case personal
    case other

    var id: String { rawValue }

    var title: String {
        switch self {
        case .documents: "Documents"
        case .keys: "Keys"
        case .money: "Money"
        case .jewelry: "Jewelry"
        case .electronics: "Electronics"
        case .travel: "Travel"
        case .health: "Health"
        case .home: "Home"
        case .personal: "Personal"
        case .other: "Other"
        }
    }

    var symbolName: String {
        switch self {
        case .documents: "doc.text.fill"
        case .keys: "key.fill"
        case .money: "banknote.fill"
        case .jewelry: "sparkles"
        case .electronics: "externaldrive.fill"
        case .travel: "airplane"
        case .health: "cross.case.fill"
        case .home: "house.fill"
        case .personal: "person.crop.circle.fill"
        case .other: "archivebox.fill"
        }
    }
}

