#if os(macOS)
import AppKit

final class BreakView: NSView {
    var remainingSeconds: Int = BreakSession.defaultDuration {
        didSet { needsDisplay = true }
    }
    var highlightedTasks: [String] = [] {
        didSet { needsDisplay = true }
    }

    private var animationStart = CACurrentMediaTime()
    private var displayTimer: Timer?
    private let scene = FatCatScene.allCases.randomElement() ?? .walk

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.backgroundColor = NSColor.black.withAlphaComponent(0.42).cgColor
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

    override func hitTest(_ point: NSPoint) -> NSView? { self }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let time = CACurrentMediaTime() - animationStart
        drawHighlightedTasks()
        drawMessage(for: scene)
        drawCat(for: scene, time: time)
    }

    private func catPosition(time: TimeInterval) -> NSPoint {
        let travelWidth = bounds.width + FatCatArt.canvasSize.width
        let x = CGFloat((time * 125).truncatingRemainder(dividingBy: travelWidth)) - FatCatArt.canvasSize.width
        let baseY = max(90, bounds.height * 0.25)
        return NSPoint(x: x, y: baseY)
    }

    private func centeredCatRect(y: CGFloat) -> NSRect {
        NSRect(
            x: (bounds.width - FatCatArt.canvasSize.width) / 2,
            y: y,
            width: FatCatArt.canvasSize.width,
            height: FatCatArt.canvasSize.height
        )
    }

    private func drawMessage(for scene: FatCatScene) {
        let title = scene.title
        let countdown = "\(scene.subtitle)，\(remainingSeconds) 秒后让路"
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 36, weight: .bold),
            .foregroundColor: NSColor.white,
            .paragraphStyle: paragraph
        ]
        let countdownAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 20, weight: .medium),
            .foregroundColor: NSColor.white.withAlphaComponent(0.86),
            .paragraphStyle: paragraph
        ]

        title.draw(in: NSRect(x: 20, y: bounds.midY + 34, width: bounds.width - 40, height: 50), withAttributes: titleAttributes)
        countdown.draw(in: NSRect(x: 20, y: bounds.midY - 6, width: bounds.width - 40, height: 34), withAttributes: countdownAttributes)
    }

    private func drawHighlightedTasks() {
        let visibleTasks = Array(highlightedTasks.prefix(4))
        guard !visibleTasks.isEmpty else { return }

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        paragraph.lineBreakMode = .byTruncatingTail
        let leftInset = max(42, bounds.width * 0.07)
        let columnWidth = min(max(280, bounds.width * 0.28), 420)
        let labelAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 15, weight: .semibold),
            .foregroundColor: NSColor.white.withAlphaComponent(0.78),
            .paragraphStyle: paragraph
        ]
        let baseY = bounds.midY + 118
        "Today".draw(
            in: NSRect(x: leftInset + 4, y: baseY + 28, width: columnWidth, height: 22),
            withAttributes: labelAttributes
        )

        let taskAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 20, weight: .bold),
            .foregroundColor: NSColor.white,
            .paragraphStyle: paragraph
        ]
        let pillHeight: CGFloat = 38
        let spacing: CGFloat = 10
        let totalHeight = CGFloat(visibleTasks.count) * pillHeight + CGFloat(max(0, visibleTasks.count - 1)) * spacing
        var y = baseY - totalHeight

        for task in visibleTasks.reversed() {
            let width = min(columnWidth, max(220, task.size(withAttributes: taskAttributes).width + 56))
            let rect = NSRect(x: leftInset, y: y, width: width, height: pillHeight)
            let path = NSBezierPath(roundedRect: rect, xRadius: 19, yRadius: 19)
            NSColor.systemOrange.withAlphaComponent(0.92).setFill()
            path.fill()
            NSColor.white.withAlphaComponent(0.24).setStroke()
            path.lineWidth = 1
            path.stroke()
            task.draw(in: rect.insetBy(dx: 20, dy: 7), withAttributes: taskAttributes)
            y += pillHeight + spacing
        }
    }

    private func drawCat(for scene: FatCatScene, time: TimeInterval) {
        let rect: NSRect
        switch scene {
        case .walk:
            let position = catPosition(time: time)
            rect = NSRect(x: position.x, y: position.y, width: FatCatArt.canvasSize.width, height: FatCatArt.canvasSize.height)
        case .nap, .sign, .drink, .neck, .divination:
            rect = centeredCatRect(y: max(82, bounds.height * 0.16))
        }
        FatCatArt.draw(in: rect, phase: time, scene: scene, showsStage: false)
    }
}
#endif
