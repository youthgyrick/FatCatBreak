import XCTest
@testable import FatCatBreak

final class AppSettingsStoreTests: XCTestCase {
    func testSettingsClampAcceptedRanges() {
        XCTAssertEqual(AppSettingsStore.clampInterval(0.01), 0.1)
        XCTAssertEqual(AppSettingsStore.clampInterval(200), 168)
        XCTAssertEqual(AppSettingsStore.clampDuration(0), 1)
        XCTAssertEqual(AppSettingsStore.clampDuration(700), 600)
    }
}
