enum SensitivityLevel: String, CaseIterable, Identifiable {
    case normal
    case privateItem
    case highlyPrivate

    var id: String { rawValue }

    var title: String {
        switch self {
        case .normal: "Normal"
        case .privateItem: "Private"
        case .highlyPrivate: "Highly Private"
        }
    }

    var description: String {
        switch self {
        case .normal: "Visible in your list."
        case .privateItem: "Can be hidden when Discreet Mode is on."
        case .highlyPrivate: "Always treated as sensitive."
        }
    }

    var shouldMaskInDiscreetMode: Bool {
        self != .normal
    }
}

