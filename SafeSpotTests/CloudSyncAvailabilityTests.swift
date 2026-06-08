import CloudKit
import XCTest
@testable import SafeSpot

final class CloudSyncAvailabilityTests: XCTestCase {
    func testMapsAvailableAccountStatus() {
        XCTAssertEqual(
            CloudSyncAvailability(accountStatus: .available),
            .available
        )
    }

    func testMapsUnavailableAccountStatuses() {
        XCTAssertEqual(
            CloudSyncAvailability(accountStatus: .noAccount),
            .noAccount
        )
        XCTAssertEqual(
            CloudSyncAvailability(accountStatus: .restricted),
            .restricted
        )
        XCTAssertEqual(
            CloudSyncAvailability(accountStatus: .temporarilyUnavailable),
            .temporarilyUnavailable
        )
        XCTAssertEqual(
            CloudSyncAvailability(accountStatus: .couldNotDetermine),
            .unavailable
        )
    }
}
