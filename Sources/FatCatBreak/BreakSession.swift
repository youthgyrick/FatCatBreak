import Foundation

struct BreakSession: Equatable {
    static let defaultDuration = 20

    let duration: Int
    private(set) var elapsed: Int = 0

    init(duration: Int = BreakSession.defaultDuration) {
        self.duration = max(1, duration)
    }

    var remaining: Int {
        max(0, duration - elapsed)
    }

    var isComplete: Bool {
        remaining == 0
    }

    mutating func tick() {
        elapsed = min(duration, elapsed + 1)
    }
}
