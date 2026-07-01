#if os(macOS)
import AppKit

final class MainViewController: NSViewController, NSTextFieldDelegate, NSTextViewDelegate, NSWindowDelegate {
    private enum Tab { case todo, divination, settings }
    private struct HexagramGridMetrics {
        let firstColumnWidth: CGFloat
        let bodyColumnWidth: CGFloat
        let firstRowHeight: CGFloat
        let bodyRowHeight: CGFloat
        let headerSymbolSize: CGFloat
        let headerTitleSize: CGFloat
        let headerElementSize: CGFloat
        let cellTitleSize: CGFloat
        let symbolWidth: CGFloat
        let symbolHeight: CGFloat
        let symbolFontSize: CGFloat
    }
    private enum BoardLane: CaseIterable {
        case today
        case p0
        case p1
        case completed

        var title: String {
            switch self {
            case .today: return "Today"
            case .p0: return "P0"
            case .p1: return "P1"
            case .completed: return "Completed"
            }
        }

        var accent: NSColor {
            switch self {
            case .today: return NSColor.systemBlue
            case .p0: return NSColor.systemRed
            case .p1: return NSColor.systemOrange
            case .completed: return NSColor.systemGreen
            }
        }
    }

    private var selectedTab: Tab = .todo
    private let todoStore = TodoTaskStore()
    private let hexagramCatalog = HexagramCatalog.load()
    private var tasks: [TodoTask] = []
    private var filter: TodoTaskFilter = .today
    private var isAddingTask = false
    private var selectedHexagramNumber: Int?
    private var hexagramQueryMessage = ""
    private weak var hexagramDetailPanel: NSPanel?
    private weak var yaociPreviewPanel: NSPanel?
    private weak var taskDetailPanel: NSPanel?
    private var settings: AppSettings
    private let onTakeBreakNow: () -> Void
    private let onApplySettings: (AppSettings) -> Void
    private let onQuit: () -> Void

    private let rootStack = NSStackView()
    private let tabStack = NSStackView()
    private let contentView = NSView()
    private let todoButton = NSButton(title: "Todo", target: nil, action: nil)
    private let divinationButton = NSButton(title: "64 Hexagrams", target: nil, action: nil)
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
        rootStack.spacing = 14
        rootStack.edgeInsets = NSEdgeInsets(top: 14, left: 16, bottom: 16, right: 16)
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
        tabStack.spacing = 12
        [todoButton, divinationButton, settingsButton].forEach { button in
            button.target = self
            button.isBordered = false
            button.bezelStyle = .rounded
            button.font = .systemFont(ofSize: 16, weight: .medium)
            button.contentTintColor = .secondaryLabelColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 38).isActive = true
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 112).isActive = true
        }
        todoButton.action = #selector(selectTodo)
        divinationButton.action = #selector(selectDivination)
        settingsButton.action = #selector(selectSettings)
        tabStack.addArrangedSubview(NSView())
        tabStack.addArrangedSubview(todoButton)
        tabStack.addArrangedSubview(divinationButton)
        tabStack.addArrangedSubview(settingsButton)
        tabStack.addArrangedSubview(NSView())
        rootStack.addArrangedSubview(tabStack)
        rootStack.addArrangedSubview(contentView)
    }

    private func render() {
        todoButton.contentTintColor = selectedTab == .todo ? .systemOrange : .secondaryLabelColor
        divinationButton.contentTintColor = selectedTab == .divination ? .systemOrange : .secondaryLabelColor
        settingsButton.contentTintColor = selectedTab == .settings ? .systemOrange : .secondaryLabelColor
        todoButton.font = .systemFont(ofSize: 16, weight: selectedTab == .todo ? .semibold : .medium)
        divinationButton.font = .systemFont(ofSize: 16, weight: selectedTab == .divination ? .semibold : .medium)
        settingsButton.font = .systemFont(ofSize: 16, weight: selectedTab == .settings ? .semibold : .medium)
        contentView.subviews.forEach { $0.removeFromSuperview() }
        let child: NSView
        switch selectedTab {
        case .todo:
            child = buildTodoPage()
        case .divination:
            child = buildDivinationPage()
        case .settings:
            child = buildSettingsPage()
        }
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
    @objc private func selectDivination() { selectedTab = .divination; render() }
    @objc private func selectSettings() { selectedTab = .settings; render() }

    private func buildTodoPage() -> NSView {
        let split = NSStackView()
        split.orientation = .horizontal
        split.spacing = 12
        split.distribution = .fill
        split.addArrangedSubview(buildFocusCard())
        split.addArrangedSubview(buildTaskPanel())
        split.arrangedSubviews[0].widthAnchor.constraint(equalToConstant: 342).isActive = true
        return split
    }

    private func buildDivinationPage() -> NSView {
        let split = NSStackView()
        split.orientation = .horizontal
        split.spacing = 12
        split.distribution = .fill
        split.addArrangedSubview(buildFocusCard())
        split.addArrangedSubview(buildHexagramPanel())
        split.arrangedSubviews[0].widthAnchor.constraint(equalToConstant: 342).isActive = true
        return split
    }

    private func buildFocusCard() -> NSView {
        let card = styledCard(radius: 18, background: .white)
        let stack = vStack(spacing: 18)
        stack.edgeInsets = NSEdgeInsets(top: 20, left: 18, bottom: 18, right: 18)
        addPinned(stack, to: card)

        let cat = CatTheaterView(frame: NSRect(x: 0, y: 0, width: 260, height: 180))
        cat.heightAnchor.constraint(equalToConstant: 214).isActive = true

        let bubble = bubbleBadge(" ")
        let stage = NSView()
        stage.wantsLayer = true
        stage.layer?.cornerRadius = 14
        stage.layer?.backgroundColor = NSColor(calibratedWhite: 0.995, alpha: 1).cgColor
        stage.translatesAutoresizingMaskIntoConstraints = false
        stage.heightAnchor.constraint(equalToConstant: 214).isActive = true
        stage.addSubview(cat)
        cat.translatesAutoresizingMaskIntoConstraints = false
        stage.addSubview(bubble)
        NSLayoutConstraint.activate([
            cat.leadingAnchor.constraint(equalTo: stage.leadingAnchor, constant: 18),
            cat.trailingAnchor.constraint(equalTo: stage.trailingAnchor, constant: -18),
            cat.bottomAnchor.constraint(equalTo: stage.bottomAnchor, constant: -12),
            cat.topAnchor.constraint(equalTo: stage.topAnchor, constant: 14),
            bubble.leadingAnchor.constraint(equalTo: stage.leadingAnchor, constant: 46),
            bubble.topAnchor.constraint(equalTo: stage.topAnchor, constant: 40)
        ])

        let focusTitle = label("和胖猫一起打个盹", size: 25, weight: .bold, alignment: .center)
        let focusSubtitle = label("专注当下，休息一下会更好哦～", size: 16, color: .secondaryLabelColor, alignment: .center)
        cat.onSceneChange = { [weak focusTitle, weak focusSubtitle] scene in
            focusTitle?.stringValue = scene.title
            focusSubtitle?.stringValue = scene.subtitle
        }
        stack.addArrangedSubview(stage)
        stack.addArrangedSubview(focusTitle)
        stack.addArrangedSubview(focusSubtitle)

        let counts = todoStore.todayCounts(in: tasks)
        let stat = NSStackView()
        stat.orientation = .horizontal
        stat.distribution = .fillEqually
        stat.spacing = 0
        stat.addArrangedSubview(statBox(title: "Today", value: "\(counts.total)"))
        stat.addArrangedSubview(statDivider())
        stat.addArrangedSubview(statBox(title: "Done", value: "\(counts.completed)"))
        stat.addArrangedSubview(statDivider())
        stat.addArrangedSubview(statBox(title: "Remaining", value: "\(counts.remaining)"))
        stack.addArrangedSubview(stat)

        let nextBreak = styledCard(radius: 18, background: NSColor(calibratedRed: 1, green: 0.99, blue: 0.96, alpha: 1))
        let nextStack = vStack(spacing: 10)
        nextStack.edgeInsets = NSEdgeInsets(top: 18, left: 24, bottom: 18, right: 24)
        addPinned(nextStack, to: nextBreak)
        nextStack.addArrangedSubview(label("下一次休息", size: 18, weight: .semibold, alignment: .center))
        nextStack.addArrangedSubview(label("FatCat 将在休息时间叫醒你", size: 13, color: .secondaryLabelColor, alignment: .center))
        nextStack.addArrangedSubview(label("in \(formatInterval(settings.triggerIntervalHours))", size: 24, weight: .bold, color: .systemOrange, alignment: .center))
        nextStack.addArrangedSubview(label("今天 16:30", size: 13, color: .secondaryLabelColor, alignment: .center))
        let progress = progressBar()
        nextStack.addArrangedSubview(progress)
        stack.addArrangedSubview(nextBreak)

        let breakButton = primaryButton("Take Break Now", action: #selector(takeBreakNowTapped), filled: true, icon: "☕")
        breakButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
        stack.addArrangedSubview(breakButton)
        stack.addArrangedSubview(NSView())
        return card
    }

    private func buildTaskPanel() -> NSView {
        let panel = styledCard(radius: 18, background: .white)
        let stack = vStack(spacing: 20)
        stack.edgeInsets = NSEdgeInsets(top: 22, left: 22, bottom: 18, right: 22)
        addPinned(stack, to: panel)

        let heading = vStack(spacing: 8)
        heading.addArrangedSubview(label("Tasks ✨", size: 30, weight: .bold))
        heading.addArrangedSubview(label("专注当下，完成重要的事", size: 14, color: .secondaryLabelColor))
        stack.addArrangedSubview(heading)

        stack.addArrangedSubview(buildInputRow())

        let board = NSGridView(views: [BoardLane.allCases.map { laneColumn(for: $0) }])
        board.columnSpacing = 12
        board.rowSpacing = 0
        for column in 0..<BoardLane.allCases.count {
            board.column(at: column).xPlacement = .fill
        }
        stack.addArrangedSubview(board)
        return panel
    }

    private func buildHexagramPanel() -> NSView {
        let panel = styledCard(radius: 18, background: .white)
        let stack = vStack(spacing: 10)
        stack.edgeInsets = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        addPinned(stack, to: panel)
        let metrics = hexagramGridMetrics()

        let header = NSStackView()
        header.orientation = .horizontal
        header.alignment = .centerY
        header.spacing = 14
        header.addArrangedSubview(label("64卦查询 ✨", size: 26, weight: .bold))
        header.addArrangedSubview(NSView())
        let query = NSTextField(string: "")
        query.identifier = NSUserInterfaceItemIdentifier("hexagramQuery")
        query.placeholderString = "输入卦序，如 1、2、43"
        query.font = .systemFont(ofSize: 15)
        query.target = self
        query.action = #selector(queryHexagramTapped)
        query.widthAnchor.constraint(equalToConstant: 330).isActive = true
        query.heightAnchor.constraint(equalToConstant: 36).isActive = true
        header.addArrangedSubview(query)
        let button = primaryButton("查询", action: #selector(queryHexagramTapped), filled: true)
        button.widthAnchor.constraint(equalToConstant: 72).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        header.addArrangedSubview(button)
        header.heightAnchor.constraint(equalToConstant: 42).isActive = true
        stack.addArrangedSubview(header)

        let gridWrap = NSView()
        let grid = buildHexagramGrid(metrics: metrics)
        grid.translatesAutoresizingMaskIntoConstraints = false
        gridWrap.addSubview(grid)
        NSLayoutConstraint.activate([
            grid.centerXAnchor.constraint(equalTo: gridWrap.centerXAnchor),
            grid.centerYAnchor.constraint(equalTo: gridWrap.centerYAnchor),
            grid.widthAnchor.constraint(equalToConstant: metrics.firstColumnWidth + metrics.bodyColumnWidth * 8),
            grid.heightAnchor.constraint(equalToConstant: metrics.firstRowHeight + metrics.bodyRowHeight * 8)
        ])
        stack.addArrangedSubview(gridWrap)
        return panel
    }

    private func buildHexagramGrid(metrics: HexagramGridMetrics) -> NSView {
        let order = hexagramCatalog.trigramOrder
        let rows = [[""] + order] + order.map { lower in
            [lower] + order.map { upper in
                hexagramCatalog.hexagram(upper: upper, lower: lower)?.name ?? ""
            }
        }

        let gridRows: [[NSView]] = rows.enumerated().map { rowIndex, row in
            row.enumerated().map { columnIndex, value in
                if rowIndex == 0 && columnIndex == 0 {
                    return cornerHeaderCell(metrics: metrics)
                }
                if rowIndex == 0 {
                    return trigramHeaderCell(name: value, index: columnIndex, metrics: metrics)
                }
                if columnIndex == 0 {
                    return trigramHeaderCell(name: value, index: rowIndex, metrics: metrics)
                }
                let lower = order[rowIndex - 1]
                let upper = order[columnIndex - 1]
                guard let hexagram = hexagramCatalog.hexagram(upper: upper, lower: lower) else {
                    return emptyHexagramCell()
                }
                return hexagramCard(hexagram, metrics: metrics)
            }
        }

        let grid = NSGridView(views: gridRows)
        grid.rowSpacing = 0
        grid.columnSpacing = 0
        for column in 0..<grid.numberOfColumns {
            grid.column(at: column).xPlacement = .fill
            grid.column(at: column).width = column == 0 ? metrics.firstColumnWidth : metrics.bodyColumnWidth
        }
        for row in 0..<grid.numberOfRows {
            grid.row(at: row).yPlacement = .fill
            grid.row(at: row).height = row == 0 ? metrics.firstRowHeight : metrics.bodyRowHeight
        }
        grid.wantsLayer = true
        grid.layer?.cornerRadius = 12
        grid.layer?.borderWidth = 1
        grid.layer?.borderColor = NSColor(calibratedWhite: 0.88, alpha: 1).cgColor
        return grid
    }

    private func cornerHeaderCell(metrics: HexagramGridMetrics) -> NSView {
        let cell = matrixCell(background: NSColor(calibratedWhite: 0.985, alpha: 1))
        let text = label("上卦\n\n下卦", size: metrics.headerTitleSize, weight: .semibold, color: .secondaryLabelColor, alignment: .center)
        text.maximumNumberOfLines = 3
        addCentered(text, to: cell)
        return cell
    }

    private func trigramHeaderCell(name: String, index: Int, metrics: HexagramGridMetrics) -> NSView {
        let cell = matrixCell(background: NSColor(calibratedWhite: 0.99, alpha: 1))
        let stack = NSStackView()
        stack.orientation = .horizontal
        stack.alignment = .centerY
        stack.spacing = 6
        stack.edgeInsets = NSEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        let trigram = hexagramCatalog.trigrams[name]
        stack.addArrangedSubview(label(trigram?.symbol ?? "", size: metrics.headerSymbolSize, weight: .bold, alignment: .center))
        let text = vStack(spacing: 0)
        text.alignment = .leading
        text.addArrangedSubview(label("\(index) \(name)", size: metrics.headerTitleSize, weight: .semibold))
        text.addArrangedSubview(label(trigram?.element ?? "", size: metrics.headerElementSize, weight: .medium, color: .secondaryLabelColor))
        stack.addArrangedSubview(text)
        addPinned(stack, to: cell)
        return cell
    }

    private func hexagramCard(_ hexagram: Hexagram, metrics: HexagramGridMetrics) -> NSView {
        let selected = selectedHexagramNumber == hexagram.number
        let button = NSButton(title: "", target: self, action: #selector(hexagramTapped(_:)))
        button.identifier = NSUserInterfaceItemIdentifier("\(hexagram.number)")
        button.isBordered = false
        button.wantsLayer = true
        button.layer?.backgroundColor = (selected ? NSColor(calibratedRed: 1, green: 0.95, blue: 0.88, alpha: 1) : .white).cgColor
        button.layer?.borderWidth = selected ? 2 : 1
        button.layer?.borderColor = (selected ? NSColor.systemOrange : NSColor(calibratedWhite: 0.88, alpha: 1)).cgColor
        button.layer?.shadowColor = NSColor.black.cgColor
        button.layer?.shadowOpacity = selected ? 0.10 : 0
        button.layer?.shadowRadius = selected ? 8 : 0
        button.layer?.shadowOffset = NSSize(width: 0, height: 2)

        let stack = vStack(spacing: 1)
        stack.alignment = .centerX
        stack.edgeInsets = NSEdgeInsets(top: 8, left: 5, bottom: 5, right: 5)
        let title = label("\(hexagram.name) \(String(format: "%02d", hexagram.number))", size: metrics.cellTitleSize, weight: .medium, alignment: .center)
        title.lineBreakMode = .byTruncatingTail
        title.maximumNumberOfLines = 1
        title.usesSingleLineMode = true
        title.heightAnchor.constraint(equalToConstant: metrics.cellTitleSize + 4).isActive = true
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(hexagramSymbol(hexagram, width: metrics.symbolWidth, height: metrics.symbolHeight, size: metrics.symbolFontSize))
        addPinned(stack, to: button)
        return button
    }

    private func hexagramGridMetrics() -> HexagramGridMetrics {
        let totalWidth = max(view.bounds.width, 1180)
        let totalHeight = max(view.bounds.height, 780)
        let rightWidth = max(720, totalWidth - 342 - 12 - 32)
        let rightHeight = max(620, totalHeight - 14 - 16 - 32)
        let innerWidth = rightWidth - 40
        let innerHeight = rightHeight - 20 - 36 - 12

        let bodyColumnWidth = floor((innerWidth - 56) / 8.0)
        let firstColumnWidth = floor(max(60, min(78, bodyColumnWidth * 0.72)))
        let bodyRowHeight = floor((innerHeight - 64) / 8.0)
        let firstRowHeight = floor(max(66, min(84, bodyRowHeight * 0.95)))

        let headerSymbolSize = max(22, min(28, bodyColumnWidth * 0.24))
        let headerTitleSize = max(12, min(15, bodyColumnWidth * 0.14))
        let headerElementSize = max(12, min(14, bodyColumnWidth * 0.13))
        let cellTitleSize = max(12, min(14, bodyColumnWidth * 0.14))
        let symbolWidth = max(52, bodyColumnWidth - 18)
        let symbolHeight = max(46, bodyRowHeight - 26)
        let symbolFontSize = max(16, min(20, bodyRowHeight * 0.26))

        return HexagramGridMetrics(
            firstColumnWidth: firstColumnWidth,
            bodyColumnWidth: bodyColumnWidth,
            firstRowHeight: firstRowHeight,
            bodyRowHeight: bodyRowHeight,
            headerSymbolSize: headerSymbolSize,
            headerTitleSize: headerTitleSize,
            headerElementSize: headerElementSize,
            cellTitleSize: cellTitleSize,
            symbolWidth: symbolWidth,
            symbolHeight: symbolHeight,
            symbolFontSize: symbolFontSize
        )
    }

    private func emptyHexagramCell() -> NSView {
        matrixCell(background: .white)
    }

    private func matrixCell(background: NSColor) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = background.cgColor
        view.layer?.borderWidth = 0.5
        view.layer?.borderColor = NSColor(calibratedWhite: 0.88, alpha: 1).cgColor
        return view
    }

    private func buildInputRow() -> NSView {
        let row = NSStackView()
        row.orientation = .horizontal
        row.spacing = 12
        let title = NSTextField(string: "")
        title.placeholderString = "添加新任务，按 Enter 快速创建"
        title.identifier = NSUserInterfaceItemIdentifier("newTaskTitle")
        title.font = .systemFont(ofSize: 16)
        title.isBordered = false
        title.focusRingType = .none
        title.drawsBackground = false
        title.target = self
        title.action = #selector(addTaskTapped)
        let titleWrap = inputContainer()
        titleWrap.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: titleWrap.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: titleWrap.trailingAnchor, constant: -16),
            title.centerYAnchor.constraint(equalTo: titleWrap.centerYAnchor)
        ])
        titleWrap.heightAnchor.constraint(equalToConstant: 50).isActive = true
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let date = NSDatePicker()
        date.identifier = NSUserInterfaceItemIdentifier("newTaskDate")
        date.datePickerElements = .yearMonthDay
        date.datePickerStyle = .textField
        date.isBordered = false
        date.drawsBackground = false
        date.dateValue = Date()
        let dateWrap = inputContainer()
        let calendar = label("◴", size: 17)
        let dateStack = NSStackView()
        dateStack.orientation = .horizontal
        dateStack.alignment = .centerY
        dateStack.spacing = 8
        dateStack.translatesAutoresizingMaskIntoConstraints = false
        dateStack.addArrangedSubview(calendar)
        dateStack.addArrangedSubview(date)
        dateWrap.addSubview(dateStack)
        NSLayoutConstraint.activate([
            dateStack.leadingAnchor.constraint(equalTo: dateWrap.leadingAnchor, constant: 16),
            dateStack.trailingAnchor.constraint(equalTo: dateWrap.trailingAnchor, constant: -16),
            dateStack.centerYAnchor.constraint(equalTo: dateWrap.centerYAnchor)
        ])
        dateWrap.heightAnchor.constraint(equalToConstant: 50).isActive = true
        dateWrap.widthAnchor.constraint(equalToConstant: 188).isActive = true

        let laneWrap = inputContainer()
        laneWrap.widthAnchor.constraint(equalToConstant: 170).isActive = true
        laneWrap.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let laneMenu = NSPopUpButton()
        laneMenu.identifier = NSUserInterfaceItemIdentifier("newTaskLane")
        laneMenu.isBordered = false
        laneMenu.font = .systemFont(ofSize: 16, weight: .medium)
        laneMenu.addItems(withTitles: ["Today", "P0", "P1"])
        laneMenu.selectItem(withTitle: "Today")
        laneMenu.target = self
        laneMenu.action = #selector(newTaskLaneChanged(_:))
        laneWrap.addSubview(laneMenu)
        laneMenu.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            laneMenu.leadingAnchor.constraint(equalTo: laneWrap.leadingAnchor, constant: 12),
            laneMenu.trailingAnchor.constraint(equalTo: laneWrap.trailingAnchor, constant: -12),
            laneMenu.centerYAnchor.constraint(equalTo: laneWrap.centerYAnchor)
        ])

        let add = primaryButton("＋ Add", action: #selector(addTaskTapped), filled: true)
        add.heightAnchor.constraint(equalToConstant: 50).isActive = true
        add.widthAnchor.constraint(equalToConstant: 110).isActive = true
        row.addArrangedSubview(titleWrap)
        row.addArrangedSubview(dateWrap)
        row.addArrangedSubview(laneWrap)
        row.addArrangedSubview(add)
        return row
    }

    private func taskRow(_ task: TodoTask) -> NSView {
        let row = styledCard(radius: 14, background: .white)
        row.widthAnchor.constraint(equalToConstant: 224).isActive = true
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.spacing = 0
        stack.edgeInsets = NSEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        addPinned(stack, to: row)
        row.heightAnchor.constraint(greaterThanOrEqualToConstant: 58).isActive = true

        let check = NSButton(checkboxWithTitle: "", target: self, action: #selector(toggleTask(_:)))
        check.identifier = NSUserInterfaceItemIdentifier(task.id)
        check.state = task.completed ? .on : .off
        let header = NSStackView()
        header.orientation = .horizontal
        header.alignment = .centerY
        header.spacing = 10
        let title = NSButton(title: task.title, target: self, action: #selector(openTaskDetail(_:)))
        title.identifier = NSUserInterfaceItemIdentifier(task.id)
        title.isBordered = false
        title.bezelStyle = .regularSquare
        title.setButtonType(.momentaryChange)
        title.font = .systemFont(ofSize: 15, weight: .medium)
        let hasDescription = !task.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        title.contentTintColor = hasDescription ? .systemBlue : (task.completed ? .secondaryLabelColor : .labelColor)
        title.focusRingType = .none
        title.cell?.lineBreakMode = .byTruncatingTail
        title.cell?.wraps = false
        title.cell?.alignment = .left
        title.setContentHuggingPriority(.defaultLow, for: .horizontal)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        title.widthAnchor.constraint(equalToConstant: 142).isActive = true
        if task.completed || hasDescription {
            var attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 15, weight: .medium),
                .foregroundColor: hasDescription ? NSColor.systemBlue : NSColor.secondaryLabelColor
            ]
            if hasDescription {
                attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
            }
            if task.completed {
                attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
            }
            title.attributedTitle = NSAttributedString(string: task.title, attributes: attributes)
            title.toolTip = hasDescription ? "View task details" : nil
        }
        let delete = NSButton(image: trashImage(), target: self, action: #selector(deleteTask(_:)))
        delete.identifier = NSUserInterfaceItemIdentifier(task.id)
        delete.isBordered = false
        delete.bezelStyle = .regularSquare
        delete.contentTintColor = .secondaryLabelColor
        header.addArrangedSubview(check)
        header.addArrangedSubview(title)
        header.addArrangedSubview(delete)

        stack.addArrangedSubview(header)
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

    @objc private func queryHexagramTapped() {
        guard let field = findView(id: "hexagramQuery") as? NSTextField else { return }
        let value = field.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let number = Int(value), let hexagram = hexagramCatalog.hexagram(number: number) else {
            selectedHexagramNumber = nil
            hexagramQueryMessage = "未找到对应卦序"
            render()
            return
        }
        selectedHexagramNumber = hexagram.number
        hexagramQueryMessage = "已高亮第 \(hexagram.number) 卦"
        render()
    }

    @objc private func hexagramTapped(_ sender: NSButton) {
        guard let raw = sender.identifier?.rawValue,
              let number = Int(raw),
              let hexagram = hexagramCatalog.hexagram(number: number) else { return }
        selectedHexagramNumber = hexagram.number
        hexagramQueryMessage = ""
        render()
        showHexagramDetail(hexagram)
    }

    @objc private func newTaskLaneChanged(_ sender: NSPopUpButton) {
        guard let date = findView(id: "newTaskDate") as? NSDatePicker else { return }
        date.dateValue = defaultDate(forLaneTitle: sender.titleOfSelectedItem ?? "Today")
    }

    @objc private func addTaskTapped() {
        guard !isAddingTask else { return }
        guard let titleField = findView(id: "newTaskTitle") as? NSTextField else { return }
        let title = titleField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        isAddingTask = true
        let dueDate = (findView(id: "newTaskDate") as? NSDatePicker).map { TodoTaskStore.dateKey(for: $0.dateValue) }
        tasks.append(TodoTask(title: title, dueDate: dueDate))
        todoStore.saveTasks(tasks)
        render()
        DispatchQueue.main.async { [weak self] in
            self?.isAddingTask = false
        }
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

    @objc private func openTaskDetail(_ sender: NSButton) {
        guard let id = sender.identifier?.rawValue,
              let task = tasks.first(where: { $0.id == id }) else { return }
        showTaskDetail(task)
    }

    @objc private func cancelTaskDetail() {
        closeTaskDetailPanel()
    }

    @objc private func saveTaskDetail() {
        guard let panel = taskDetailPanel,
              let taskID = panel.identifier?.rawValue,
              let index = tasks.firstIndex(where: { $0.id == taskID }),
              let titleField = findView(id: "taskDetailTitle", in: panel.contentView) as? NSTextField,
              let datePicker = findView(id: "taskDetailDate", in: panel.contentView) as? NSDatePicker,
              let textView = findView(id: "taskDetailDescription", in: panel.contentView) as? NSTextView else { return }

        let title = titleField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else {
            updateTaskDetailValidation()
            return
        }

        tasks[index].title = title
        tasks[index].description = textView.string
        tasks[index].dueDate = TodoTaskStore.dateKey(for: datePicker.dateValue)
        if let tags = findView(id: "taskDetailTag", in: panel.contentView) as? NSSegmentedControl {
            applyTaskDetailTag(tags.selectedSegment, to: &tasks[index])
        }
        todoStore.saveTasks(tasks)
        closeTaskDetailPanel()
        render()
    }

    @objc private func taskDetailTagChanged(_ sender: NSSegmentedControl) {
        guard let panel = taskDetailPanel,
              let datePicker = findView(id: "taskDetailDate", in: panel.contentView) as? NSDatePicker else { return }
        switch sender.selectedSegment {
        case 0:
            datePicker.dateValue = defaultDate(forLaneTitle: "Today")
        case 1:
            datePicker.dateValue = defaultDate(forLaneTitle: "P0")
        case 2:
            datePicker.dateValue = defaultDate(forLaneTitle: "P1")
        default:
            break
        }
    }

    @objc private func applySettingsTapped() {
        let intervalValue = Double((findView(id: "interval") as? NSTextField)?.stringValue ?? "") ?? settings.triggerIntervalHours
        let durationValue = Int((findView(id: "duration") as? NSTextField)?.stringValue ?? "") ?? settings.stayDurationSeconds
        let login = (findView(id: "launchAtLogin") as? NSButton)?.state == .on
        settings = AppSettings(triggerIntervalHours: AppSettingsStore.clampInterval(intervalValue), stayDurationSeconds: AppSettingsStore.clampDuration(durationValue), launchAtLogin: login)
        onApplySettings(settings)
        render()
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

    private func defaultDate(forLaneTitle title: String) -> Date {
        let calendar = Calendar.current
        switch title {
        case "P0":
            return calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        case "P1":
            return calendar.date(byAdding: .day, value: 2, to: Date()) ?? Date()
        default:
            return Date()
        }
    }

    private func taskDetailTagIndex(for task: TodoTask) -> Int {
        guard task.completed || task.dueDate != nil else { return 2 }
        switch boardLane(for: task) {
        case .today:
            return 0
        case .p0:
            return 1
        case .p1:
            return 2
        case .completed:
            return 3
        }
    }

    private func applyTaskDetailTag(_ selectedSegment: Int, to task: inout TodoTask) {
        switch selectedSegment {
        case 0:
            task.completed = false
            task.completedAt = nil
            task.dueDate = TodoTaskStore.dateKey(for: defaultDate(forLaneTitle: "Today"))
        case 1:
            task.completed = false
            task.completedAt = nil
            task.dueDate = TodoTaskStore.dateKey(for: defaultDate(forLaneTitle: "P0"))
        case 2:
            task.completed = false
            task.completedAt = nil
            task.dueDate = TodoTaskStore.dateKey(for: defaultDate(forLaneTitle: "P1"))
        case 3:
            task.completed = true
            task.completedAt = task.completedAt ?? ISO8601DateFormatter().string(from: Date())
        default:
            break
        }
    }

    private func boardLane(for task: TodoTask, today: Date = Date()) -> BoardLane {
        if task.completed { return .completed }
        guard let dueDate = task.dueDate else { return .p1 }
        if dueDate == TodoTaskStore.dateKey(for: today) { return .today }
        if let parsed = parseDateKey(dueDate),
           let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today),
           parsed <= Calendar.current.startOfDay(for: tomorrow) {
            return .p0
        }
        return .p1
    }

    private func laneTasks(_ lane: BoardLane) -> [TodoTask] {
        let today = Date()
        return tasks.filter { boardLane(for: $0, today: today) == lane }.sorted { lhs, rhs in
            switch lane {
            case .completed:
                return (lhs.completedAt ?? lhs.createdAt) > (rhs.completedAt ?? rhs.createdAt)
            case .today, .p0, .p1:
                switch (lhs.dueDate, rhs.dueDate) {
                case let (left?, right?) where left != right: return left < right
                case (_?, nil): return true
                case (nil, _?): return false
                default: return lhs.createdAt < rhs.createdAt
                }
            }
        }
    }

    private func laneColumn(for lane: BoardLane) -> NSView {
        let column = styledCard(radius: 18, background: .white)
        column.layer?.borderColor = NSColor.separatorColor.cgColor
        let stack = vStack(spacing: 12)
        stack.edgeInsets = NSEdgeInsets(top: 14, left: 12, bottom: 12, right: 12)
        addPinned(stack, to: column)
        column.widthAnchor.constraint(equalToConstant: 248).isActive = true

        let header = NSStackView()
        header.orientation = .horizontal
        header.alignment = .centerY
        header.spacing = 8
        header.addArrangedSubview(dot(lane.accent))
        header.addArrangedSubview(label(lane.title, size: 15, weight: .semibold))
        header.addArrangedSubview(countBadge("\(laneTasks(lane).count)"))
        header.addArrangedSubview(NSView())
        stack.addArrangedSubview(header)

        let tasksStack = vStack(spacing: 10)
        tasksStack.alignment = .width
        let laneItems = laneTasks(lane)
        if laneItems.isEmpty {
            let empty = styledCard(radius: 14, background: NSColor(calibratedWhite: 0.997, alpha: 1))
            empty.widthAnchor.constraint(equalToConstant: 224).isActive = true
            let emptyLabel = label("No tasks", size: 14, color: .secondaryLabelColor, alignment: .center)
            empty.addSubview(emptyLabel)
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: empty.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: empty.centerYAnchor),
                empty.heightAnchor.constraint(equalToConstant: 78)
            ])
            tasksStack.addArrangedSubview(empty)
        } else {
            for task in laneItems {
                tasksStack.addArrangedSubview(taskRow(task))
            }
        }
        stack.addArrangedSubview(tasksStack)
        stack.addArrangedSubview(NSView())
        return column
    }

    private func showTaskDetail(_ task: TodoTask) {
        closeTaskDetailPanel()

        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 560, height: 460),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isFloatingPanel = true
        panel.hidesOnDeactivate = false
        panel.isReleasedWhenClosed = false
        panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
        panel.standardWindowButton(.zoomButton)?.isHidden = true
        panel.standardWindowButton(.closeButton)?.target = self
        panel.standardWindowButton(.closeButton)?.action = #selector(cancelTaskDetail)
        panel.contentMinSize = NSSize(width: 560, height: 460)
        panel.setContentSize(NSSize(width: 560, height: 460))
        panel.identifier = NSUserInterfaceItemIdentifier(task.id)
        panel.delegate = self
        panel.contentView = taskDetailView(task)
        panel.center()
        taskDetailPanel = panel

        if let hostWindow = view.window {
            hostWindow.beginSheet(panel)
        } else {
            panel.makeKeyAndOrderFront(nil)
        }

        DispatchQueue.main.async { [weak self, weak panel] in
            guard let self, let panel,
                  let titleField = self.findView(id: "taskDetailTitle", in: panel.contentView) as? NSTextField else { return }
            panel.makeFirstResponder(titleField)
            self.updateTaskDetailValidation()
        }
    }

    private func taskDetailView(_ task: TodoTask) -> NSView {
        let root = NSView(frame: NSRect(x: 0, y: 0, width: 560, height: 460))
        root.translatesAutoresizingMaskIntoConstraints = false
        root.widthAnchor.constraint(equalToConstant: 560).isActive = true
        root.heightAnchor.constraint(equalToConstant: 460).isActive = true

        let titleWrap = inputContainer()
        titleWrap.identifier = NSUserInterfaceItemIdentifier("taskDetailTitleWrap")
        let titleField = NSTextField(string: task.title)
        titleField.identifier = NSUserInterfaceItemIdentifier("taskDetailTitle")
        titleField.isBordered = false
        titleField.drawsBackground = false
        titleField.focusRingType = .none
        titleField.font = .systemFont(ofSize: 16, weight: .medium)
        titleField.delegate = self
        titleWrap.addSubview(titleField)
        titleField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleField.leadingAnchor.constraint(equalTo: titleWrap.leadingAnchor, constant: 14),
            titleField.trailingAnchor.constraint(equalTo: titleWrap.trailingAnchor, constant: -14),
            titleField.topAnchor.constraint(equalTo: titleWrap.topAnchor, constant: 12),
            titleField.bottomAnchor.constraint(equalTo: titleWrap.bottomAnchor, constant: -12),
            titleWrap.heightAnchor.constraint(equalToConstant: 46)
        ])

        let dateWrap = inputContainer()
        let datePicker = NSDatePicker()
        datePicker.identifier = NSUserInterfaceItemIdentifier("taskDetailDate")
        datePicker.datePickerElements = .yearMonthDay
        datePicker.datePickerStyle = .textFieldAndStepper
        datePicker.datePickerMode = .single
        datePicker.isBordered = true
        datePicker.drawsBackground = true
        datePicker.focusRingType = .none
        datePicker.font = .systemFont(ofSize: 14)
        datePicker.dateValue = parseDateKey(task.dueDate ?? "") ?? Date()
        dateWrap.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: dateWrap.leadingAnchor, constant: 14),
            datePicker.trailingAnchor.constraint(equalTo: dateWrap.trailingAnchor, constant: -14),
            datePicker.topAnchor.constraint(equalTo: dateWrap.topAnchor, constant: 9),
            datePicker.bottomAnchor.constraint(equalTo: dateWrap.bottomAnchor, constant: -9),
            dateWrap.widthAnchor.constraint(equalToConstant: 170),
            dateWrap.heightAnchor.constraint(equalToConstant: 46)
        ])

        let descriptionWrap = inputContainer()
        descriptionWrap.translatesAutoresizingMaskIntoConstraints = false
        let descriptionScroll = NSScrollView()
        descriptionScroll.hasVerticalScroller = true
        descriptionScroll.borderType = .noBorder
        descriptionScroll.drawsBackground = false
        let descriptionText = NSTextView(frame: NSRect(x: 0, y: 0, width: 500, height: 260))
        descriptionText.identifier = NSUserInterfaceItemIdentifier("taskDetailDescription")
        descriptionText.delegate = self
        descriptionText.isRichText = false
        descriptionText.isAutomaticQuoteSubstitutionEnabled = false
        descriptionText.isAutomaticDashSubstitutionEnabled = false
        descriptionText.isHorizontallyResizable = false
        descriptionText.isVerticallyResizable = true
        descriptionText.minSize = NSSize(width: 0, height: 260)
        descriptionText.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        descriptionText.autoresizingMask = [.width]
        descriptionText.textContainerInset = NSSize(width: 6, height: 8)
        descriptionText.textContainer?.widthTracksTextView = true
        descriptionText.textContainer?.containerSize = NSSize(width: 500, height: CGFloat.greatestFiniteMagnitude)
        descriptionText.font = .systemFont(ofSize: 14)
        descriptionText.drawsBackground = false
        descriptionText.string = task.description
        descriptionScroll.documentView = descriptionText
        descriptionWrap.addSubview(descriptionScroll)
        let placeholder = PassthroughTextField(labelWithString: "Add details about this task...")
        placeholder.identifier = NSUserInterfaceItemIdentifier("taskDetailDescriptionPlaceholder")
        placeholder.font = .systemFont(ofSize: 14)
        placeholder.textColor = .placeholderTextColor
        descriptionWrap.addSubview(placeholder)
        descriptionScroll.translatesAutoresizingMaskIntoConstraints = false
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionScroll.leadingAnchor.constraint(equalTo: descriptionWrap.leadingAnchor, constant: 10),
            descriptionScroll.trailingAnchor.constraint(equalTo: descriptionWrap.trailingAnchor, constant: -10),
            descriptionScroll.topAnchor.constraint(equalTo: descriptionWrap.topAnchor, constant: 10),
            descriptionScroll.bottomAnchor.constraint(equalTo: descriptionWrap.bottomAnchor, constant: -10),
            descriptionWrap.heightAnchor.constraint(equalToConstant: 216),
            placeholder.leadingAnchor.constraint(equalTo: descriptionWrap.leadingAnchor, constant: 16),
            placeholder.topAnchor.constraint(equalTo: descriptionWrap.topAnchor, constant: 14)
        ])

        let tags = NSSegmentedControl(labels: ["Today", "P0", "P1", "Complete"], trackingMode: .selectOne, target: self, action: #selector(taskDetailTagChanged(_:)))
        tags.identifier = NSUserInterfaceItemIdentifier("taskDetailTag")
        tags.segmentStyle = .rounded
        tags.selectedSegment = taskDetailTagIndex(for: task)
        tags.setWidth(78, forSegment: 0)
        tags.setWidth(70, forSegment: 1)
        tags.setWidth(70, forSegment: 2)
        tags.setWidth(104, forSegment: 3)

        let divider = separator()
        let buttons = NSStackView()
        buttons.orientation = .horizontal
        buttons.alignment = .centerY
        buttons.spacing = 10
        buttons.addArrangedSubview(NSView())
        let cancel = primaryButton("Cancel", action: #selector(cancelTaskDetail), filled: false)
        cancel.keyEquivalent = "\u{1b}"
        cancel.widthAnchor.constraint(equalToConstant: 92).isActive = true
        let save = primaryButton("Save", action: #selector(saveTaskDetail), filled: true)
        save.identifier = NSUserInterfaceItemIdentifier("taskDetailSave")
        save.keyEquivalent = "s"
        save.keyEquivalentModifierMask = [.command]
        save.widthAnchor.constraint(equalToConstant: 92).isActive = true
        save.heightAnchor.constraint(equalToConstant: 34).isActive = true
        cancel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        buttons.addArrangedSubview(cancel)
        buttons.addArrangedSubview(save)

        [titleWrap, dateWrap, descriptionWrap, tags, divider, buttons].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            root.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleWrap.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 20),
            titleWrap.trailingAnchor.constraint(equalTo: dateWrap.leadingAnchor, constant: -14),
            titleWrap.topAnchor.constraint(equalTo: root.topAnchor, constant: 22),

            dateWrap.trailingAnchor.constraint(equalTo: root.trailingAnchor, constant: -20),
            dateWrap.topAnchor.constraint(equalTo: titleWrap.topAnchor),

            descriptionWrap.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 20),
            descriptionWrap.trailingAnchor.constraint(equalTo: root.trailingAnchor, constant: -20),
            descriptionWrap.topAnchor.constraint(equalTo: titleWrap.bottomAnchor, constant: 18),

            tags.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 20),
            tags.topAnchor.constraint(equalTo: descriptionWrap.bottomAnchor, constant: 12),
            tags.heightAnchor.constraint(equalToConstant: 32),

            divider.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: root.trailingAnchor, constant: -20),
            divider.topAnchor.constraint(equalTo: tags.bottomAnchor, constant: 12),

            buttons.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 20),
            buttons.trailingAnchor.constraint(equalTo: root.trailingAnchor, constant: -20),
            buttons.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 12),
            buttons.bottomAnchor.constraint(equalTo: root.bottomAnchor, constant: -18)
        ])

        updateTaskDescriptionPlaceholder(in: root)
        return root
    }

    private func updateTaskDetailValidation() {
        guard let panel = taskDetailPanel,
              let titleField = findView(id: "taskDetailTitle", in: panel.contentView) as? NSTextField,
              let titleWrap = findView(id: "taskDetailTitleWrap", in: panel.contentView),
              let saveButton = findView(id: "taskDetailSave", in: panel.contentView) as? NSButton else { return }

        let title = titleField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let isValid = !title.isEmpty
        saveButton.isEnabled = isValid
        saveButton.alphaValue = isValid ? 1.0 : 0.55
        titleWrap.layer?.borderColor = (isValid ? NSColor(calibratedWhite: 0.90, alpha: 1) : NSColor.systemRed.withAlphaComponent(0.75)).cgColor
    }

    private func updateTaskDescriptionPlaceholder(in root: NSView?) {
        guard let root,
              let textView = findView(id: "taskDetailDescription", in: root) as? NSTextView,
              let placeholder = findView(id: "taskDetailDescriptionPlaceholder", in: root) as? NSTextField else { return }
        placeholder.isHidden = !textView.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func closeTaskDetailPanel() {
        guard let panel = taskDetailPanel else { return }
        if let parent = panel.sheetParent {
            parent.endSheet(panel)
        }
        panel.orderOut(nil)
        panel.close()
        taskDetailPanel = nil
    }

    private func parseDateKey(_ value: String) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: value)
    }

    private func showHexagramDetail(_ hexagram: Hexagram) {
        let explanation = hexagramCatalog.explanation(for: hexagram)
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 760, height: 760),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isFloatingPanel = true
        panel.hidesOnDeactivate = false
        panel.isReleasedWhenClosed = false
        panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
        panel.standardWindowButton(.zoomButton)?.isHidden = true
        panel.contentView = hexagramDetailView(hexagram, explanation: explanation)
        panel.center()
        hexagramDetailPanel = panel

        if let hostWindow = view.window {
            hostWindow.beginSheet(panel)
        } else {
            NSApp.runModal(for: panel)
        }
    }

    private func hexagramDetailView(_ hexagram: Hexagram, explanation: HexagramExplanation?) -> NSView {
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 728, height: 700))
        let stack = vStack(spacing: 10)
        stack.edgeInsets = NSEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)
        addPinned(stack, to: container)

        let titleRow = NSStackView()
        titleRow.orientation = .horizontal
        titleRow.alignment = .centerY
        titleRow.spacing = 10
        titleRow.addArrangedSubview(detailHeaderIconView())
        titleRow.addArrangedSubview(label("卦意解析", size: 22, weight: .bold))
        titleRow.addArrangedSubview(NSView())
        stack.addArrangedSubview(titleRow)

        let top = NSStackView()
        top.orientation = .horizontal
        top.alignment = .top
        top.spacing = 16
        let symbolWrap = styledCard(radius: 12, background: NSColor(calibratedWhite: 0.995, alpha: 1))
        symbolWrap.widthAnchor.constraint(equalToConstant: 108).isActive = true
        symbolWrap.heightAnchor.constraint(equalToConstant: 132).isActive = true
        addCentered(hexagramSymbol(hexagram, width: 84, height: 108, size: 28), to: symbolWrap)
        top.addArrangedSubview(symbolWrap)

        let meta = vStack(spacing: 4)
        meta.addArrangedSubview(label("第 \(hexagram.number) 卦  \(hexagram.name)", size: 20, weight: .bold))
        meta.addArrangedSubview(label("短名：\(hexagram.shortName)", size: 13, color: .secondaryLabelColor))
        meta.addArrangedSubview(label("上卦：\(hexagram.upperTrigram.name) / \(hexagram.upperTrigram.element)", size: 13, color: .secondaryLabelColor))
        meta.addArrangedSubview(label("下卦：\(hexagram.lowerTrigram.name) / \(hexagram.lowerTrigram.element)", size: 13, color: .secondaryLabelColor))
        meta.addArrangedSubview(label("binary：\(hexagram.binary ?? "")", size: 13, color: .secondaryLabelColor))
        meta.addArrangedSubview(label("Unicode：\(hexagram.unicode ?? "无")", size: 13, color: .secondaryLabelColor))
        top.addArrangedSubview(meta)
        top.addArrangedSubview(NSView())
        stack.addArrangedSubview(top)

        let scroll = NSScrollView()
        scroll.hasVerticalScroller = true
        scroll.borderType = .noBorder
        scroll.drawsBackground = false
        scroll.identifier = NSUserInterfaceItemIdentifier("hexagramDetailScroll")
        let content = FlippedStackView()
        content.orientation = .vertical
        content.spacing = 12
        content.edgeInsets = NSEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        content.translatesAutoresizingMaskIntoConstraints = false
        let rawText = explanation?.rawText.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if let hexagramImageView = hexagramImageSection(for: hexagram) {
            content.addArrangedSubview(hexagramImageView)
        }
        content.addArrangedSubview(detailSection(title: "卦意解析", body: rawText.isEmpty ? "暂无解析" : rawText))
        if let yaociView = yaociImageSection(for: hexagram) {
            content.addArrangedSubview(yaociView)
        }
        scroll.documentView = content
        NSLayoutConstraint.activate([
            content.widthAnchor.constraint(equalToConstant: 668)
        ])
        scroll.heightAnchor.constraint(equalToConstant: 470).isActive = true
        stack.addArrangedSubview(scroll)

        let buttonRow = NSStackView()
        buttonRow.orientation = .horizontal
        buttonRow.alignment = .centerY
        buttonRow.addArrangedSubview(NSView())
        let closeButton = primaryButton("关闭", action: #selector(closeHexagramDetail), filled: true)
        closeButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        buttonRow.addArrangedSubview(closeButton)
        buttonRow.addArrangedSubview(NSView())
        stack.addArrangedSubview(buttonRow)

        DispatchQueue.main.async { [weak scroll] in
            guard let scroll else { return }
            scroll.contentView.scroll(to: .zero)
            scroll.reflectScrolledClipView(scroll.contentView)
        }
        return container
    }

    @objc private func closeHexagramDetail() {
        guard let panel = hexagramDetailPanel else { return }
        if let parent = panel.sheetParent {
            parent.endSheet(panel)
        } else {
            NSApp.stopModal()
            panel.orderOut(nil)
        }
        panel.close()
        hexagramDetailPanel = nil
    }

    private func detailSection(title: String, body: String) -> NSView {
        let section = vStack(spacing: 5)
        section.addArrangedSubview(label(title, size: 15, weight: .semibold, color: .systemOrange))
        section.addArrangedSubview(label(body, size: 14, color: .labelColor))
        return section
    }

    private func hexagramImageSection(for hexagram: Hexagram) -> NSView? {
        guard let imageURL = hexagramImageURL(for: hexagram),
              let image = NSImage(contentsOf: imageURL) else {
            NSLog("Warning: missing detail image for hexagram %d %@", hexagram.number, hexagram.name)
            return nil
        }
        let wrap = styledCard(radius: 12, background: .white)
        wrap.layer?.borderColor = NSColor(calibratedWhite: 0.90, alpha: 1).cgColor
        let button = NSButton(title: "", target: self, action: #selector(openYaociPreview(_:)))
        button.identifier = NSUserInterfaceItemIdentifier(imageURL.path)
        button.toolTip = "\(hexagram.name)卦图"
        button.image = image
        button.imageScaling = .scaleProportionallyUpOrDown
        button.imagePosition = .imageOnly
        button.isBordered = false
        button.bezelStyle = .regularSquare
        addPinned(button, to: wrap)
        wrap.heightAnchor.constraint(equalToConstant: 320).isActive = true
        return wrap
    }

    private func yaociImageSection(for hexagram: Hexagram) -> NSView? {
        guard let imageURL = yaociImageURL(for: hexagram),
              let image = NSImage(contentsOf: imageURL) else {
            NSLog("Warning: missing yaoci image for hexagram %d %@", hexagram.number, hexagram.name)
            return nil
        }
        let section = vStack(spacing: 8)
        section.addArrangedSubview(label("爻辞截图", size: 15, weight: .semibold, color: .systemOrange))
        let wrap = styledCard(radius: 12, background: .white)
        wrap.layer?.borderColor = NSColor(calibratedWhite: 0.90, alpha: 1).cgColor
        let button = NSButton(title: "", target: self, action: #selector(openYaociPreview(_:)))
        button.identifier = NSUserInterfaceItemIdentifier(imageURL.path)
        button.toolTip = "爻辞截图"
        button.image = image
        button.imageScaling = .scaleProportionallyUpOrDown
        button.imagePosition = .imageOnly
        button.isBordered = false
        button.bezelStyle = .regularSquare
        addPinned(button, to: wrap)
        wrap.heightAnchor.constraint(equalToConstant: 280).isActive = true
        section.addArrangedSubview(wrap)
        return section
    }

    private func hexagramImageURL(for hexagram: Hexagram) -> URL? {
        let fileName = String(format: "%02d%@.png", hexagram.number, hexagram.name)
        if let bundled = Bundle.main.url(forResource: String(format: "%02d%@", hexagram.number, hexagram.name), withExtension: "png", subdirectory: "64gua_detail_images") {
            return bundled
        }
        let fallback = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent("outputs/64gua_detail_images")
            .appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: fallback.path) ? fallback : nil
    }

    private func yaociImageURL(for hexagram: Hexagram) -> URL? {
        let fileName = "\(hexagram.name).png"
        if let bundled = Bundle.main.url(forResource: hexagram.name, withExtension: "png", subdirectory: "64gua_yaoci_images") {
            return bundled
        }
        let fallback = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent("outputs/64gua_yaoci_images")
            .appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: fallback.path) ? fallback : nil
    }

    @objc private func openYaociPreview(_ sender: NSButton) {
        guard let path = sender.identifier?.rawValue,
              let image = NSImage(contentsOfFile: path) else { return }
        let title = sender.toolTip?.isEmpty == false ? sender.toolTip! : "图片预览"

        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 900, height: 820),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        panel.title = title
        panel.isReleasedWhenClosed = false
        panel.center()
        panel.standardWindowButton(.miniaturizeButton)?.isHidden = true

        let root = NSView(frame: NSRect(x: 0, y: 0, width: 900, height: 820))
        let stack = vStack(spacing: 10)
        stack.edgeInsets = NSEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        addPinned(stack, to: root)

        let toolbar = NSStackView()
        toolbar.orientation = .horizontal
        toolbar.alignment = .centerY
        toolbar.spacing = 10
        toolbar.addArrangedSubview(label(title, size: 18, weight: .bold))
        toolbar.addArrangedSubview(NSView())
        let backButton = primaryButton("返回", action: #selector(closeYaociPreview), filled: false)
        backButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        let zoomOut = primaryButton("－", action: #selector(zoomOutYaociPreview), filled: false)
        zoomOut.widthAnchor.constraint(equalToConstant: 36).isActive = true
        let zoomIn = primaryButton("＋", action: #selector(zoomInYaociPreview), filled: false)
        zoomIn.widthAnchor.constraint(equalToConstant: 36).isActive = true
        toolbar.addArrangedSubview(backButton)
        toolbar.addArrangedSubview(zoomOut)
        toolbar.addArrangedSubview(zoomIn)
        stack.addArrangedSubview(toolbar)

        let scroll = NSScrollView()
        scroll.hasVerticalScroller = true
        scroll.hasHorizontalScroller = true
        scroll.allowsMagnification = true
        scroll.minMagnification = 0.5
        scroll.maxMagnification = 3.0
        scroll.magnification = 1.0
        scroll.borderType = .noBorder
        scroll.drawsBackground = false

        let imageView = NSImageView(image: image)
        imageView.imageScaling = .scaleNone
        imageView.frame = NSRect(origin: .zero, size: image.size)
        imageView.identifier = NSUserInterfaceItemIdentifier("yaociPreviewImage")
        scroll.documentView = imageView
        scroll.identifier = NSUserInterfaceItemIdentifier("yaociPreviewScroll")
        stack.addArrangedSubview(scroll)

        panel.contentView = root
        yaociPreviewPanel = panel
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc private func zoomInYaociPreview() {
        adjustYaociPreviewMagnification(delta: 0.2)
    }

    @objc private func zoomOutYaociPreview() {
        adjustYaociPreviewMagnification(delta: -0.2)
    }

    private func adjustYaociPreviewMagnification(delta: CGFloat) {
        guard let scroll = findView(id: "yaociPreviewScroll", in: yaociPreviewPanel?.contentView) as? NSScrollView else { return }
        let next = min(scroll.maxMagnification, max(scroll.minMagnification, scroll.magnification + delta))
        scroll.setMagnification(next, centeredAt: NSPoint(x: scroll.bounds.midX, y: scroll.bounds.midY))
    }

    @objc private func closeYaociPreview() {
        guard let panel = yaociPreviewPanel else { return }
        panel.orderOut(nil)
        panel.close()
        yaociPreviewPanel = nil
        hexagramDetailPanel?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func controlTextDidChange(_ obj: Notification) {
        guard let field = obj.object as? NSTextField,
              field.identifier?.rawValue == "taskDetailTitle" else { return }
        updateTaskDetailValidation()
    }

    func textDidChange(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView,
              textView.identifier?.rawValue == "taskDetailDescription",
              let panel = taskDetailPanel else { return }
        updateTaskDescriptionPlaceholder(in: panel.contentView)
    }

    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSWindow,
              window === taskDetailPanel else { return }
        taskDetailPanel = nil
    }

    private func detailHeaderIconView() -> NSView {
        let wrap = styledCard(radius: 12, background: .white)
        wrap.layer?.borderColor = NSColor(calibratedWhite: 0.90, alpha: 1).cgColor
        let imageView = NSImageView()
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.imageAlignment = .alignCenter
        let fallback = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("Resources/HexagramDetailHeaderIcon.png").path
        imageView.image = Bundle.main.image(forResource: "HexagramDetailHeaderIcon") ?? NSImage(contentsOfFile: fallback)
        addPinned(imageView, to: wrap)
        wrap.widthAnchor.constraint(equalToConstant: 48).isActive = true
        wrap.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return wrap
    }

    private func vStack(spacing: CGFloat) -> NSStackView { let s = NSStackView(); s.orientation = .vertical; s.spacing = spacing; return s }
    private func styledCard(radius: CGFloat = 14, background: NSColor = NSColor(calibratedWhite: 0.99, alpha: 1)) -> NSView { let v = NSView(); v.wantsLayer = true; v.layer?.cornerRadius = radius; v.layer?.borderWidth = 1; v.layer?.borderColor = NSColor(calibratedWhite: 0.92, alpha: 1).cgColor; v.layer?.backgroundColor = background.cgColor; return v }
    private func addPinned(_ child: NSView, to parent: NSView) { child.translatesAutoresizingMaskIntoConstraints = false; parent.addSubview(child); NSLayoutConstraint.activate([child.leadingAnchor.constraint(equalTo: parent.leadingAnchor), child.trailingAnchor.constraint(equalTo: parent.trailingAnchor), child.topAnchor.constraint(equalTo: parent.topAnchor), child.bottomAnchor.constraint(equalTo: parent.bottomAnchor)]) }
    private func addCentered(_ child: NSView, to parent: NSView) { child.translatesAutoresizingMaskIntoConstraints = false; parent.addSubview(child); NSLayoutConstraint.activate([child.centerXAnchor.constraint(equalTo: parent.centerXAnchor), child.centerYAnchor.constraint(equalTo: parent.centerYAnchor)]) }
    private func hexagramSymbol(_ hexagram: Hexagram, width: CGFloat, height: CGFloat, size: CGFloat) -> NSView {
        let symbol = HexagramSymbolView(linesTopToBottom: hexagram.displayLinesTopToBottom, fontSize: size)
        symbol.widthAnchor.constraint(equalToConstant: width).isActive = true
        symbol.heightAnchor.constraint(equalToConstant: height).isActive = true
        return symbol
    }
    private func label(_ text: String, size: CGFloat, weight: NSFont.Weight = .regular, color: NSColor = .labelColor, alignment: NSTextAlignment = .left) -> NSTextField { let l = NSTextField(labelWithString: text); l.font = .systemFont(ofSize: size, weight: weight); l.textColor = color; l.alignment = alignment; l.lineBreakMode = .byWordWrapping; return l }
    private func separator() -> NSView { let v = NSView(); v.wantsLayer = true; v.layer?.backgroundColor = NSColor.separatorColor.cgColor; v.heightAnchor.constraint(equalToConstant: 1).isActive = true; return v }
    private func primaryButton(_ title: String, action: Selector, filled: Bool = false, icon: String? = nil) -> NSButton { let b = NSButton(title: icon.map { "\($0)  \(title)" } ?? title, target: self, action: action); b.bezelStyle = .rounded; b.font = .systemFont(ofSize: 16, weight: .semibold); b.isBordered = true; if filled { b.contentTintColor = .white; b.bezelColor = .systemOrange } else { b.contentTintColor = .systemOrange }; return b }
    private func secondaryPillButton(_ title: String) -> NSButton { let b = NSButton(title: title, target: nil, action: nil); b.bezelStyle = .rounded; b.font = .systemFont(ofSize: 14, weight: .medium); b.contentTintColor = .secondaryLabelColor; return b }
    private func trashImage() -> NSImage {
        if let image = NSImage(systemSymbolName: "trash", accessibilityDescription: "Delete") {
            return image
        }
        return NSImage(size: NSSize(width: 16, height: 16), flipped: false) { rect in
            NSColor.secondaryLabelColor.setStroke()
            let path = NSBezierPath(rect: rect.insetBy(dx: 4, dy: 4))
            path.lineWidth = 1.6
            path.stroke()
            return true
        }
    }
    private func statBox(title: String, value: String) -> NSView { let s = vStack(spacing: 6); s.alignment = .centerX; s.addArrangedSubview(label(value, size: 24, weight: .bold, color: .systemOrange, alignment: .center)); s.addArrangedSubview(label(title, size: 13, color: .secondaryLabelColor, alignment: .center)); return s }
    private func statDivider() -> NSView { let v = NSView(); v.wantsLayer = true; v.layer?.backgroundColor = NSColor(calibratedWhite: 0.92, alpha: 1).cgColor; v.widthAnchor.constraint(equalToConstant: 1).isActive = true; return v }
    private func countBadge(_ value: String) -> NSView { let badge = styledCard(radius: 11, background: NSColor(calibratedWhite: 0.97, alpha: 1)); badge.layer?.borderWidth = 0; let text = label(value, size: 13, weight: .medium, color: .secondaryLabelColor, alignment: .center); badge.addSubview(text); text.translatesAutoresizingMaskIntoConstraints = false; NSLayoutConstraint.activate([text.leadingAnchor.constraint(equalTo: badge.leadingAnchor, constant: 8), text.trailingAnchor.constraint(equalTo: badge.trailingAnchor, constant: -8), text.topAnchor.constraint(equalTo: badge.topAnchor, constant: 3), text.bottomAnchor.constraint(equalTo: badge.bottomAnchor, constant: -3)]); return badge }
    private func dot(_ color: NSColor) -> NSView { let v = NSView(); v.wantsLayer = true; v.layer?.cornerRadius = 5; v.layer?.backgroundColor = color.cgColor; v.widthAnchor.constraint(equalToConstant: 10).isActive = true; v.heightAnchor.constraint(equalToConstant: 10).isActive = true; return v }
    private func bubbleBadge(_ text: String) -> NSView { let badge = styledCard(radius: 16, background: .white); badge.layer?.shadowColor = NSColor.black.withAlphaComponent(0.08).cgColor; badge.layer?.shadowOpacity = 1; badge.layer?.shadowRadius = 8; badge.layer?.shadowOffset = NSSize(width: 0, height: 2); let heart = label("❤", size: 16, color: .systemOrange, alignment: .center); badge.addSubview(heart); heart.translatesAutoresizingMaskIntoConstraints = false; NSLayoutConstraint.activate([heart.leadingAnchor.constraint(equalTo: badge.leadingAnchor, constant: 12), heart.trailingAnchor.constraint(equalTo: badge.trailingAnchor, constant: -12), heart.topAnchor.constraint(equalTo: badge.topAnchor, constant: 7), heart.bottomAnchor.constraint(equalTo: badge.bottomAnchor, constant: -7)]); return badge }
    private func inputContainer() -> NSView { let v = styledCard(radius: 14, background: .white); v.layer?.borderColor = NSColor(calibratedWhite: 0.90, alpha: 1).cgColor; return v }
    private func progressBar() -> NSView { let outer = NSView(); outer.wantsLayer = true; outer.layer?.cornerRadius = 3; outer.layer?.backgroundColor = NSColor(calibratedWhite: 0.94, alpha: 1).cgColor; outer.heightAnchor.constraint(equalToConstant: 6).isActive = true; let inner = NSView(); inner.wantsLayer = true; inner.layer?.cornerRadius = 3; inner.layer?.backgroundColor = NSColor.systemOrange.cgColor; outer.addSubview(inner); inner.translatesAutoresizingMaskIntoConstraints = false; NSLayoutConstraint.activate([inner.leadingAnchor.constraint(equalTo: outer.leadingAnchor), inner.topAnchor.constraint(equalTo: outer.topAnchor), inner.bottomAnchor.constraint(equalTo: outer.bottomAnchor), inner.widthAnchor.constraint(equalTo: outer.widthAnchor, multiplier: 0.38)]); return outer }
    private func labeledField(_ title: String, value: String, id: String, suffix: String) -> NSView { let row = NSStackView(); row.orientation = .horizontal; row.spacing = 12; row.alignment = .centerY; let titleLabel = label(title, size: 16); titleLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true; let field = NSTextField(string: value); field.identifier = NSUserInterfaceItemIdentifier(id); field.widthAnchor.constraint(equalToConstant: 100).isActive = true; row.addArrangedSubview(titleLabel); row.addArrangedSubview(field); row.addArrangedSubview(label(suffix, size: 14, color: .secondaryLabelColor)); return row }
}

final class CatTheaterView: NSView {
    private let animationStart = CACurrentMediaTime()
    private var displayTimer: Timer?
    private let sceneDuration: TimeInterval = 5.5
    private var currentScene: FatCatScene?
    var onSceneChange: ((FatCatScene) -> Void)?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
        displayTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            self?.needsDisplay = true
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        displayTimer?.invalidate()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let time = CACurrentMediaTime() - animationStart
        let scene = scene(at: time)
        let localPhase = time.truncatingRemainder(dividingBy: sceneDuration)
        if currentScene != scene {
            currentScene = scene
            onSceneChange?(scene)
        }
        FatCatArt.draw(in: bounds, phase: localPhase, scene: scene, showsStage: true)
    }

    private func scene(at time: TimeInterval) -> FatCatScene {
        let scenes: [FatCatScene] = [.walk, .nap, .sign, .drink, .neck, .divination]
        let sceneIndex = Int(time / sceneDuration) % scenes.count
        return scenes[sceneIndex]
    }
}

final class HexagramSymbolView: NSView {
    private let linesTopToBottom: [String]
    private let fontSize: CGFloat
    private let preferredSize: NSSize

    init(linesTopToBottom: [String], fontSize: CGFloat) {
        self.linesTopToBottom = linesTopToBottom
        self.fontSize = fontSize
        preferredSize = NSSize(width: fontSize * 3.2, height: fontSize * 2.8)
        super.init(frame: .zero)
        wantsLayer = true
        layer?.backgroundColor = NSColor.clear.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isFlipped: Bool { true }
    override var intrinsicContentSize: NSSize { preferredSize }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard !linesTopToBottom.isEmpty else { return }
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: fontSize, weight: .bold),
            .foregroundColor: NSColor.labelColor,
            .paragraphStyle: paragraph
        ]
        let lineHeight = bounds.height / CGFloat(linesTopToBottom.count)
        for (index, line) in linesTopToBottom.enumerated() {
            let rect = NSRect(
                x: 0,
                y: CGFloat(index) * lineHeight + (lineHeight - fontSize) / 2 - 1,
                width: bounds.width,
                height: max(fontSize + 4, lineHeight)
            )
            (line as NSString).draw(in: rect, withAttributes: attributes)
        }
    }
}

final class HexagramDetailHeaderIconView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let bg = NSBezierPath(roundedRect: bounds, xRadius: 14, yRadius: 14)
        NSColor(calibratedRed: 1.0, green: 0.97, blue: 0.92, alpha: 1).setFill()
        bg.fill()

        let body = NSBezierPath(ovalIn: NSRect(x: 6, y: 14, width: 27, height: 18))
        NSColor.systemOrange.setFill()
        body.fill()
        NSColor.black.setStroke()
        body.lineWidth = 1.8
        body.stroke()

        let belly = NSBezierPath(ovalIn: NSRect(x: 13, y: 17, width: 12, height: 10))
        NSColor(calibratedRed: 1.0, green: 0.88, blue: 0.56, alpha: 1).setFill()
        belly.fill()

        let head = NSBezierPath(ovalIn: NSRect(x: 23, y: 20, width: 17, height: 14))
        NSColor.systemOrange.setFill()
        head.fill()
        head.lineWidth = 1.8
        NSColor.black.setStroke()
        head.stroke()

        let leftEar = NSBezierPath()
        leftEar.move(to: NSPoint(x: 27, y: 34))
        leftEar.line(to: NSPoint(x: 30, y: 42))
        leftEar.line(to: NSPoint(x: 33, y: 34))
        leftEar.close()
        let rightEar = NSBezierPath()
        rightEar.move(to: NSPoint(x: 33, y: 34))
        rightEar.line(to: NSPoint(x: 37, y: 42))
        rightEar.line(to: NSPoint(x: 39, y: 33))
        rightEar.close()
        NSColor.black.setFill()
        leftEar.fill()
        rightEar.fill()

        NSBezierPath(ovalIn: NSRect(x: 29, y: 27, width: 2.2, height: 2.2)).fill()
        NSBezierPath(ovalIn: NSRect(x: 35, y: 27, width: 2.2, height: 2.2)).fill()

        let whiskers = NSBezierPath()
        whiskers.move(to: NSPoint(x: 26, y: 26)); whiskers.line(to: NSPoint(x: 18, y: 28))
        whiskers.move(to: NSPoint(x: 26, y: 23)); whiskers.line(to: NSPoint(x: 18, y: 21))
        whiskers.move(to: NSPoint(x: 39, y: 26)); whiskers.line(to: NSPoint(x: 46, y: 28))
        whiskers.move(to: NSPoint(x: 39, y: 23)); whiskers.line(to: NSPoint(x: 46, y: 21))
        whiskers.lineWidth = 1.4
        whiskers.lineCapStyle = .round
        whiskers.stroke()

        for rect in [
            NSRect(x: 30, y: 7, width: 11, height: 11),
            NSRect(x: 38, y: 10, width: 9.5, height: 9.5),
            NSRect(x: 21, y: 5, width: 9.5, height: 9.5)
        ] {
            let coin = NSBezierPath(ovalIn: rect)
            NSColor(calibratedRed: 0.95, green: 0.73, blue: 0.22, alpha: 1).setFill()
            coin.fill()
            NSColor(calibratedRed: 0.62, green: 0.39, blue: 0.05, alpha: 1).setStroke()
            coin.lineWidth = 1.4
            coin.stroke()
            let hole = NSBezierPath(roundedRect: rect.insetBy(dx: rect.width * 0.34, dy: rect.height * 0.34), xRadius: 2, yRadius: 2)
            NSColor(calibratedRed: 1.0, green: 0.95, blue: 0.86, alpha: 1).setFill()
            hole.fill()
        }
    }
}

final class FlippedStackView: NSStackView {
    override var isFlipped: Bool { true }
}

final class PassthroughTextField: NSTextField {
    override func hitTest(_ point: NSPoint) -> NSView? {
        nil
    }
}
#endif
