import XCTest
@testable import FatCatBreak

final class BreakSessionTests: XCTestCase {
    func testDefaultSessionLastsTwentySeconds() {
        let session = BreakSession()
        XCTAssertEqual(session.duration, 20)
        XCTAssertEqual(session.remaining, 20)
        XCTAssertFalse(session.isComplete)
    }

    func testSessionCompletesAfterDuration() {
        var session = BreakSession(duration: 3)
        session.tick()
        session.tick()
        XCTAssertEqual(session.remaining, 1)
        session.tick()
        XCTAssertTrue(session.isComplete)
        XCTAssertEqual(session.remaining, 0)
    }

    func testSessionNeverRunsBelowZero() {
        var session = BreakSession(duration: 1)
        session.tick()
        session.tick()
        XCTAssertEqual(session.remaining, 0)
        XCTAssertEqual(session.elapsed, 1)
    }
}
