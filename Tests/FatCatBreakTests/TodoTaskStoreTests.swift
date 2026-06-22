import XCTest
@testable import FatCatBreak

final class TodoTaskStoreTests: XCTestCase {
    private var defaults: UserDefaults!
    private var suiteName: String!

    override func setUp() {
        super.setUp()
        suiteName = "FatCatBreakTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
    }

    func testSamplesSeedOnlyOnceAndPersist() {
        let store = TodoTaskStore(defaults: defaults)
        let seeded = store.loadTasks(today: fixedDate("2026-06-22"))
        XCTAssertFalse(seeded.isEmpty)
        store.saveTasks([TodoTask(title: "Custom", dueDate: "2026-06-22")])
        XCTAssertEqual(store.loadTasks(today: fixedDate("2026-06-22")).map(\.title), ["Custom"])
    }

    func testTodayFilterIncludesCompletedAndIncompleteTodayOnly() {
        let store = TodoTaskStore(defaults: defaults)
        let tasks = [
            TodoTask(title: "Done today", dueDate: "2026-06-22", completed: true),
            TodoTask(title: "Open today", dueDate: "2026-06-22"),
            TodoTask(title: "Tomorrow", dueDate: "2026-06-23"),
            TodoTask(title: "No date")
        ]
        let filtered = store.filteredTasks(tasks, filter: .today, today: fixedDate("2026-06-22"))
        XCTAssertEqual(filtered.map(\.title), ["Done today", "Open today"])
        XCTAssertEqual(store.todayCounts(in: tasks, today: fixedDate("2026-06-22")).completed, 1)
    }

    func testCompletedFilterOnlyShowsCompletedTasks() {
        let store = TodoTaskStore(defaults: defaults)
        let tasks = [TodoTask(title: "Done", completed: true), TodoTask(title: "Open")]
        XCTAssertEqual(store.filteredTasks(tasks, filter: .completed).map(\.title), ["Done"])
    }

    private func fixedDate(_ value: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: value)!
    }
}
