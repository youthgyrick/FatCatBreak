import Foundation

struct TodoTask: Codable, Equatable, Identifiable {
    let id: String
    var title: String
    var dueDate: String?
    var completed: Bool
    let createdAt: String
    var completedAt: String?

    init(
        id: String = UUID().uuidString,
        title: String,
        dueDate: String? = nil,
        completed: Bool = false,
        createdAt: String = ISO8601DateFormatter().string(from: Date()),
        completedAt: String? = nil
    ) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.completed = completed
        self.createdAt = createdAt
        self.completedAt = completedAt
    }
}

enum TodoTaskFilter: String, CaseIterable {
    case today = "Today"
    case all = "All Tasks"
    case completed = "Completed"
}

struct TodoTaskStore {
    private let defaults: UserDefaults
    private let tasksKey = "FatCatBreak.todo.tasks"
    private let seededKey = "FatCatBreak.todo.seededSamples"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadTasks(today: Date = Date()) -> [TodoTask] {
        if let data = defaults.data(forKey: tasksKey),
           let tasks = try? JSONDecoder().decode([TodoTask].self, from: data) {
            return tasks
        }
        guard !defaults.bool(forKey: seededKey) else { return [] }
        let samples = sampleTasks(today: today)
        saveTasks(samples)
        defaults.set(true, forKey: seededKey)
        return samples
    }

    func saveTasks(_ tasks: [TodoTask]) {
        if let data = try? JSONEncoder().encode(tasks) {
            defaults.set(data, forKey: tasksKey)
        }
    }

    func filteredTasks(_ tasks: [TodoTask], filter: TodoTaskFilter, today: Date = Date()) -> [TodoTask] {
        let todayString = Self.dateKey(for: today)
        switch filter {
        case .today:
            return tasks
                .filter { $0.dueDate == todayString }
                .sorted { lhs, rhs in
                    if lhs.completed != rhs.completed { return lhs.completed && !rhs.completed }
                    return lhs.createdAt < rhs.createdAt
                }
        case .all:
            return tasks.sorted { lhs, rhs in
                switch (lhs.dueDate, rhs.dueDate) {
                case let (left?, right?) where left != right: return left < right
                case (_?, nil): return true
                case (nil, _?): return false
                default: return lhs.createdAt < rhs.createdAt
                }
            }
        case .completed:
            return tasks.filter(\.completed).sorted { ($0.completedAt ?? $0.createdAt) > ($1.completedAt ?? $1.createdAt) }
        }
    }

    func todayCounts(in tasks: [TodoTask], today: Date = Date()) -> (total: Int, completed: Int, remaining: Int) {
        let todayString = Self.dateKey(for: today)
        let todayTasks = tasks.filter { $0.dueDate == todayString }
        let completed = todayTasks.filter(\.completed).count
        return (todayTasks.count, completed, todayTasks.count - completed)
    }

    static func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    static func displayDate(_ dueDate: String?, today: Date = Date()) -> String {
        guard let dueDate, !dueDate.isEmpty else { return "" }
        if dueDate == dateKey(for: today) { return "Today" }
        let input = DateFormatter()
        input.calendar = Calendar(identifier: .gregorian)
        input.locale = Locale(identifier: "en_US_POSIX")
        input.timeZone = .current
        input.dateFormat = "yyyy-MM-dd"
        guard let date = input.date(from: dueDate) else { return dueDate }
        let output = DateFormatter()
        output.locale = Locale(identifier: "en_US_POSIX")
        output.dateFormat = "MMM d"
        return output.string(from: date)
    }

    private func sampleTasks(today: Date) -> [TodoTask] {
        let calendar = Calendar.current
        let todayKey = Self.dateKey(for: today)
        let tomorrowKey = Self.dateKey(for: calendar.date(byAdding: .day, value: 1, to: today) ?? today)
        let afterTomorrowKey = Self.dateKey(for: calendar.date(byAdding: .day, value: 2, to: today) ?? today)
        let now = ISO8601DateFormatter().string(from: Date())
        return [
            TodoTask(title: "20 min reading", dueDate: todayKey, completed: true, completedAt: now),
            TodoTask(title: "Stretch and walk", dueDate: todayKey, completed: true, completedAt: now),
            TodoTask(title: "Review meeting notes", dueDate: todayKey),
            TodoTask(title: "Reply to email", dueDate: tomorrowKey),
            TodoTask(title: "Plan tomorrow’s priorities", dueDate: afterTomorrowKey)
        ]
    }
}
