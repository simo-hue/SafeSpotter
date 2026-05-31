import XCTest
@testable import SafeSpot

final class ReminderDateCalculatorTests: XCTestCase {
    func testPresetFrequenciesAdvanceFromReferenceDate() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 0))
        let start = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 1, day: 15)))

        XCTAssertEqual(
            ReminderDateCalculator.nextDate(from: start, frequency: .oneMonth, calendar: calendar),
            calendar.date(from: DateComponents(year: 2026, month: 2, day: 15))
        )
        XCTAssertEqual(
            ReminderDateCalculator.nextDate(from: start, frequency: .threeMonths, calendar: calendar),
            calendar.date(from: DateComponents(year: 2026, month: 4, day: 15))
        )
        XCTAssertEqual(
            ReminderDateCalculator.nextDate(from: start, frequency: .oneYear, calendar: calendar),
            calendar.date(from: DateComponents(year: 2027, month: 1, day: 15))
        )
    }

    func testNoneAndCustomHaveNoAutomaticNextDate() {
        XCTAssertNil(ReminderDateCalculator.nextDate(frequency: .none))
        XCTAssertNil(ReminderDateCalculator.nextDate(frequency: .custom))
    }
}

