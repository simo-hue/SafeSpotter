import Foundation

enum DateFormatters {
    static func display(_ date: Date) -> String {
        date.formatted(date: .abbreviated, time: .omitted)
    }

    static func displayWithTime(_ date: Date) -> String {
        date.formatted(date: .abbreviated, time: .shortened)
    }
}

