#if os(macOS)
import AppKit

final class MainViewController: NSViewController {
    private enum Tab { case todo, settings }
    private var selectedTab: Tab = .todo
    private let todoStore = TodoTaskStore()
    private var tasks: [TodoTask] = []
    private var filter: TodoTaskFilter = .today
    private var settings: AppSettings
    private let onTakeBreakNow: () -> Void
    private let onApplySettings: (AppSettings) -> Void
    private let onQuit: () -> Void

    private let rootStack = NSStackView()
    private let tabStack = NSStackView()
    private let contentView = NSView()
    private let todoButton = NSButton(title: "Todo", target: nil, action: nil)
    private let settingsButton = NSButton(title: "System Settings", target: nil, action: nil)

    init(settings: AppSettings, onTakeBreakNow: @escaping () -> Void, onApplySettings: @escaping (AppSettings) -> Void, onQuit: @escaping () -> Void) {
        self.settings = settings
        self.onTakeBreakNow = onTakeBreakNow
        self.onApplySettings = onApplySettings
        self.onQuit = onQuit
        super.init(nibName: nil, bundle: nil)
        tasks = todoStore.loadTasks()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func loadView() { view = NSView() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(calibratedWhite: 0.97, alpha: 1).cgColor
        buildShell()
        render()
    }

    private func buildShell() {
        rootStack.orientation = .vertical
        rootStack.spacing = 18
        rootStack.edgeInsets = NSEdgeInsets(top: 18, left: 22, bottom: 22, right: 22)
        rootStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rootStack)
        NSLayoutConstraint.activate([
            rootStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootStack.topAnchor.constraint(equalTo: view.topAnchor),
            rootStack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tabStack.orientation = .horizontal
        tabStack.alignment = .centerY
        tabStack.distribution = .gravityAreas
        tabStack.spacing = 18
        [todoButton, settingsButton].forEach { button in
            button.target = self
            button.isBordered = false
            button.bezelStyle = .rounded
            button.font = .systemFont(ofSize: 17, weight: .medium)
            button.contentTintColor = .secondaryLabelColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 170).isActive = true
        }
        todoButton.action = #selector(selectTodo)
        settingsButton.action = #selector(selectSettings)
        tabStack.addArrangedSubview(NSView())
        tabStack.addArrangedSubview(todoButton)
        tabStack.addArrangedSubview(settingsButton)
        tabStack.addArrangedSubview(NSView())
        rootStack.addArrangedSubview(tabStack)
        rootStack.addArrangedSubview(contentView)
    }

    private func render() {
        todoButton.contentTintColor = selectedTab == .todo ? .systemOrange : .secondaryLabelColor
        settingsButton.contentTintColor = selectedTab == .settings ? .systemOrange : .secondaryLabelColor
        contentView.subviews.forEach { $0.removeFromSuperview() }
        let child = selectedTab == .todo ? buildTodoPage() : buildSettingsPage()
        child.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(child)
        NSLayoutConstraint.activate([
            child.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            child.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            child.topAnchor.constraint(equalTo: contentView.topAnchor),
            child.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    @objc private func selectTodo() { selectedTab = .todo; render() }
    @objc private func selectSettings() { selectedTab = .settings; render() }

    private func buildTodoPage() -> NSView {
        let split = NSStackView()
        split.orientation = .horizontal
        split.spacing = 18
        split.distribution = .fill
        split.addArrangedSubview(buildFocusCard())
        split.addArrangedSubview(buildTaskPanel())
        split.arrangedSubviews[0].widthAnchor.constraint(equalToConstant: 340).isActive = true
        return split
    }

    private func buildFocusCard() -> NSView {
        let card = styledCard()
        let stack = vStack(spacing: 16)
        stack.edgeInsets = NSEdgeInsets(top: 26, left: 18, bottom: 18, right: 18)
        addPinned(stack, to: card)

        let cat = CatIconView(frame: NSRect(x: 0, y: 0, width: 220, height: 170))
        cat.heightAnchor.constraint(equalToConstant: 170).isActive = true
        stack.addArrangedSubview(cat)
        stack.addArrangedSubview(label("Today’s Focus", size: 28, weight: .bold, alignment: .center))
        stack.addArrangedSubview(label("Plan a few things,\nthen take a break.", size: 17, color: .secondaryLabelColor, alignment: .center))

        let counts = todoStore.todayCounts(in: tasks)
        let stat = NSStackView()
        stat.orientation = .horizontal
        stat.distribution = .fillEqually
        stat.spacing = 8
        stat.addArrangedSubview(statBox(title: "Today", value: "\(counts.total)"))
        stat.addArrangedSubview(statBox(title: "Completed", value: "\(counts.completed)"))
        stat.addArrangedSubview(statBox(title: "Remaining", value: "\(counts.remaining)"))
        stack.addArrangedSubview(stat)

        let nextBreak = styledCard()
        nextBreak.layer?.backgroundColor = NSColor(calibratedRed: 1, green: 0.98, blue: 0.94, alpha: 1).cgColor
        let nextStack = vStack(spacing: 3)
        nextStack.edgeInsets = NSEdgeInsets(top: 16, left: 18, bottom: 16, right: 18)
        addPinned(nextStack, to: nextBreak)
        nextStack.addArrangedSubview(label("Next Break", size: 15, weight: .bold))
        nextStack.addArrangedSubview(label("FatCat will appear in", size: 13, color: .secondaryLabelColor))
        nextStack.addArrangedSubview(label("in \(formatInterval(settings.triggerIntervalHours))", size: 25, weight: .bold, color: .systemOrange))
        nextStack.addArrangedSubview(label("Today", size: 13, color: .secondaryLabelColor))
        stack.addArrangedSubview(nextBreak)

        let breakButton = primaryButton("Take Break Now", action: #selector(takeBreakNowTapped))
        breakButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        stack.addArrangedSubview(breakButton)
        return card
    }

    private func buildTaskPanel() -> NSView {
        let panel = styledCard()
        let stack = vStack(spacing: 18)
        stack.edgeInsets = NSEdgeInsets(top: 24, left: 24, bottom: 20, right: 24)
        addPinned(stack, to: panel)

        let header = NSStackView()
        header.orientation = .horizontal
        header.alignment = .centerY
        header.addArrangedSubview(label("Today’s Tasks", size: 28, weight: .bold))
        header.addArrangedSubview(NSView())
        for taskFilter in TodoTaskFilter.allCases {
            let button = NSButton(title: taskFilter.rawValue, target: self, action: #selector(filterTapped(_:)))
            button.identifier = NSUserInterfaceItemIdentifier(taskFilter.rawValue)
            button.bezelStyle = .rounded
            button.contentTintColor = filter == taskFilter ? .systemOrange : .labelColor
            header.addArrangedSubview(button)
        }
        stack.addArrangedSubview(header)
        stack.addArrangedSubview(buildInputRow())

        let list = vStack(spacing: 8)
        for task in todoStore.filteredTasks(tasks, filter: filter) {
            list.addArrangedSubview(taskRow(task))
        }
        if list.arrangedSubviews.isEmpty { list.addArrangedSubview(label("No tasks in this view.", size: 16, color: .secondaryLabelColor, alignment: .center)) }
        stack.addArrangedSubview(list)
        stack.addArrangedSubview(separator())
        stack.addArrangedSubview(label(footerText(), size: 15, color: .secondaryLabelColor, alignment: .center))
        return panel
    }

    private func buildInputRow() -> NSView {
        let row = NSStackView()
        row.orientation = .horizontal
        row.spacing = 12
        let title = NSTextField(string: "")
        title.placeholderString = "Add a new task"
        title.identifier = NSUserInterfaceItemIdentifier("newTaskTitle")
        title.font = .systemFont(ofSize: 16)
        title.heightAnchor.constraint(equalToConstant: 42).isActive = true
        let dateControl = NSStackView()
        dateControl.orientation = .horizontal
        dateControl.spacing = 6
        dateControl.alignment = .centerY
        let dateEnabled = NSButton(checkboxWithTitle: "Due date", target: nil, action: nil)
        dateEnabled.identifier = NSUserInterfaceItemIdentifier("newTaskDateEnabled")
        let date = NSDatePicker()
        date.identifier = NSUserInterfaceItemIdentifier("newTaskDate")
        date.datePickerElements = .yearMonthDay
        date.datePickerStyle = .textFieldAndStepper
        date.drawsBackground = true
        date.heightAnchor.constraint(equalToConstant: 42).isActive = true
        date.widthAnchor.constraint(equalToConstant: 130).isActive = true
        dateControl.addArrangedSubview(dateEnabled)
        dateControl.addArrangedSubview(date)
        let add = primaryButton("＋ Add", action: #selector(addTaskTapped))
        add.heightAnchor.constraint(equalToConstant: 42).isActive = true
        add.widthAnchor.constraint(equalToConstant: 110).isActive = true
        row.addArrangedSubview(title)
        row.addArrangedSubview(dateControl)
        row.addArrangedSubview(add)
        return row
    }

    private func taskRow(_ task: TodoTask) -> NSView {
        let row = styledCard(radius: 10)
        row.layer?.backgroundColor = NSColor.white.cgColor
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.alignment = .centerY
        stack.spacing = 12
        stack.edgeInsets = NSEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        addPinned(stack, to: row)
        row.heightAnchor.constraint(equalToConstant: 64).isActive = true

        let check = NSButton(checkboxWithTitle: "", target: self, action: #selector(toggleTask(_:)))
        check.identifier = NSUserInterfaceItemIdentifier(task.id)
        check.state = task.completed ? .on : .off
        let title = label(task.title, size: 16)
        if task.completed { title.attributedStringValue = NSAttributedString(string: task.title, attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: NSColor.secondaryLabelColor]) }
        let due = label(TodoTaskStore.displayDate(task.dueDate), size: 15, color: .secondaryLabelColor, alignment: .right)
        due.widthAnchor.constraint(equalToConstant: 90).isActive = true
        let menu = NSButton(title: "•••", target: self, action: #selector(deleteTask(_:)))
        menu.identifier = NSUserInterfaceItemIdentifier(task.id)
        menu.isBordered = false
        stack.addArrangedSubview(check)
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(due)
        stack.addArrangedSubview(menu)
        return row
    }

    private func buildSettingsPage() -> NSView {
        let panel = styledCard()
        let stack = vStack(spacing: 18)
        stack.edgeInsets = NSEdgeInsets(top: 28, left: 32, bottom: 28, right: 32)
        addPinned(stack, to: panel)
        stack.addArrangedSubview(label("System Settings", size: 28, weight: .bold))
        let interval = labeledField("Trigger interval", value: "\(settings.triggerIntervalHours)", id: "interval", suffix: "hours (0.1–168)")
        let duration = labeledField("Stay duration", value: "\(settings.stayDurationSeconds)", id: "duration", suffix: "seconds (1–600)")
        stack.addArrangedSubview(interval)
        stack.addArrangedSubview(duration)
        let login = NSButton(checkboxWithTitle: "Launch FatCatBreak at login", target: nil, action: nil)
        login.identifier = NSUserInterfaceItemIdentifier("launchAtLogin")
        login.state = settings.launchAtLogin ? .on : .off
        stack.addArrangedSubview(login)
        let buttons = NSStackView()
        buttons.orientation = .horizontal
        buttons.spacing = 12
        buttons.addArrangedSubview(primaryButton("Take Break Now", action: #selector(takeBreakNowTapped)))
        buttons.addArrangedSubview(NSButton(title: "Quit", target: self, action: #selector(quitTapped)))
        buttons.addArrangedSubview(primaryButton("Apply", action: #selector(applySettingsTapped)))
        stack.addArrangedSubview(buttons)
        stack.addArrangedSubview(NSView())
        return panel
    }

    @objc private func takeBreakNowTapped() { onTakeBreakNow() }
    @objc private func quitTapped() { onQuit() }

    @objc private func filterTapped(_ sender: NSButton) {
        filter = TodoTaskFilter.allCases.first { $0.rawValue == sender.identifier?.rawValue } ?? .today
        render()
    }

    @objc private func addTaskTapped() {
        guard let titleField = findView(id: "newTaskTitle") as? NSTextField else { return }
        let title = titleField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        let dateEnabled = (findView(id: "newTaskDateEnabled") as? NSButton)?.state == .on
        let dueDate = dateEnabled ? (findView(id: "newTaskDate") as? NSDatePicker).map { TodoTaskStore.dateKey(for: $0.dateValue) } : nil
        tasks.append(TodoTask(title: title, dueDate: dueDate))
        todoStore.saveTasks(tasks)
        render()
    }

    @objc private func toggleTask(_ sender: NSButton) {
        guard let id = sender.identifier?.rawValue, let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        tasks[index].completed.toggle()
        tasks[index].completedAt = tasks[index].completed ? ISO8601DateFormatter().string(from: Date()) : nil
        todoStore.saveTasks(tasks)
        render()
    }

    @objc private func deleteTask(_ sender: NSButton) {
        guard let id = sender.identifier?.rawValue else { return }
        tasks.removeAll { $0.id == id }
        todoStore.saveTasks(tasks)
        render()
    }

    @objc private func applySettingsTapped() {
        let intervalValue = Double((findView(id: "interval") as? NSTextField)?.stringValue ?? "") ?? settings.triggerIntervalHours
        let durationValue = Int((findView(id: "duration") as? NSTextField)?.stringValue ?? "") ?? settings.stayDurationSeconds
        let login = (findView(id: "launchAtLogin") as? NSButton)?.state == .on
        settings = AppSettings(triggerIntervalHours: AppSettingsStore.clampInterval(intervalValue), stayDurationSeconds: AppSettingsStore.clampDuration(durationValue), launchAtLogin: login)
        onApplySettings(settings)
        render()
    }

    private func footerText() -> String {
        switch filter {
        case .today:
            let counts = todoStore.todayCounts(in: tasks)
            return "\(counts.completed) completed · \(counts.remaining) remaining"
        case .all:
            return "\(tasks.count) tasks total"
        case .completed:
            return "\(tasks.filter(\.completed).count) completed tasks"
        }
    }

    private func findView(id: String, in root: NSView? = nil) -> NSView? {
        let root = root ?? view
        if root.identifier?.rawValue == id { return root }
        for subview in root.subviews {
            if let found = findView(id: id, in: subview) { return found }
        }
        return nil
    }

    private func formatInterval(_ hours: Double) -> String {
        let totalMinutes = Int((hours * 60).rounded())
        return "\(totalMinutes / 60)h \(totalMinutes % 60)m"
    }

    private func vStack(spacing: CGFloat) -> NSStackView { let s = NSStackView(); s.orientation = .vertical; s.spacing = spacing; return s }
    private func styledCard(radius: CGFloat = 14) -> NSView { let v = NSView(); v.wantsLayer = true; v.layer?.cornerRadius = radius; v.layer?.borderWidth = 1; v.layer?.borderColor = NSColor.separatorColor.cgColor; v.layer?.backgroundColor = NSColor(calibratedWhite: 0.99, alpha: 1).cgColor; return v }
    private func addPinned(_ child: NSView, to parent: NSView) { child.translatesAutoresizingMaskIntoConstraints = false; parent.addSubview(child); NSLayoutConstraint.activate([child.leadingAnchor.constraint(equalTo: parent.leadingAnchor), child.trailingAnchor.constraint(equalTo: parent.trailingAnchor), child.topAnchor.constraint(equalTo: parent.topAnchor), child.bottomAnchor.constraint(equalTo: parent.bottomAnchor)]) }
    private func label(_ text: String, size: CGFloat, weight: NSFont.Weight = .regular, color: NSColor = .labelColor, alignment: NSTextAlignment = .left) -> NSTextField { let l = NSTextField(labelWithString: text); l.font = .systemFont(ofSize: size, weight: weight); l.textColor = color; l.alignment = alignment; l.lineBreakMode = .byWordWrapping; return l }
    private func separator() -> NSView { let v = NSView(); v.wantsLayer = true; v.layer?.backgroundColor = NSColor.separatorColor.cgColor; v.heightAnchor.constraint(equalToConstant: 1).isActive = true; return v }
    private func primaryButton(_ title: String, action: Selector) -> NSButton { let b = NSButton(title: title, target: self, action: action); b.bezelStyle = .rounded; b.contentTintColor = .systemOrange; b.font = .systemFont(ofSize: 16, weight: .semibold); return b }
    private func statBox(title: String, value: String) -> NSView { let s = vStack(spacing: 3); s.alignment = .centerX; s.addArrangedSubview(label(value, size: 24, weight: .bold, color: .systemOrange, alignment: .center)); s.addArrangedSubview(label(title, size: 13, color: .secondaryLabelColor, alignment: .center)); return s }
    private func labeledField(_ title: String, value: String, id: String, suffix: String) -> NSView { let row = NSStackView(); row.orientation = .horizontal; row.spacing = 12; row.alignment = .centerY; let titleLabel = label(title, size: 16); titleLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true; let field = NSTextField(string: value); field.identifier = NSUserInterfaceItemIdentifier(id); field.widthAnchor.constraint(equalToConstant: 100).isActive = true; row.addArrangedSubview(titleLabel); row.addArrangedSubview(field); row.addArrangedSubview(label(suffix, size: 14, color: .secondaryLabelColor)); return row }
}

final class CatIconView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        let scale = min(bounds.width / 260, bounds.height / 185)
        NSGraphicsContext.saveGraphicsState()
        let t = NSAffineTransform(); t.translateX(by: (bounds.width - 260 * scale) / 2, yBy: 0); t.scale(by: scale); t.concat()
        let outline = NSColor.black; let fur = NSColor.systemOrange; let cream = NSColor(calibratedRed: 1, green: 0.86, blue: 0.56, alpha: 1)
        outline.setStroke(); fur.setFill()
        let body = NSBezierPath(ovalIn: NSRect(x: 30, y: 32, width: 160, height: 96)); body.lineWidth = 6; body.fill(); body.stroke()
        cream.setFill(); NSBezierPath(ovalIn: NSRect(x: 72, y: 48, width: 78, height: 58)).fill()
        fur.setFill(); let head = NSBezierPath(ovalIn: NSRect(x: 136, y: 78, width: 94, height: 78)); head.lineWidth = 6; head.fill(); head.stroke()
        outline.setFill(); NSBezierPath(ovalIn: NSRect(x: 164, y: 118, width: 8, height: 8)).fill(); NSBezierPath(ovalIn: NSRect(x: 199, y: 118, width: 8, height: 8)).fill(); NSBezierPath(ovalIn: NSRect(x: 183, y: 101, width: 10, height: 7)).fill()
        let tail = NSBezierPath(); tail.move(to: NSPoint(x: 38, y: 82)); tail.curve(to: NSPoint(x: 8, y: 122), controlPoint1: NSPoint(x: 5, y: 86), controlPoint2: NSPoint(x: 5, y: 112)); tail.lineWidth = 14; tail.lineCapStyle = .round; fur.setStroke(); tail.stroke(); outline.setStroke(); tail.lineWidth = 5; tail.stroke()
        NSGraphicsContext.restoreGraphicsState()
    }
}
#endif
