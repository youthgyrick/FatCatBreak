#if os(macOS)
import AppKit

final class BreakView: NSView {
    var remainingSeconds: Int = BreakSession.defaultDuration {
        didSet { needsDisplay = true }
    }

    private var animationStart = CACurrentMediaTime()
    private var displayTimer: Timer?

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

    override func hitTest(_ point: NSPoint) -> NSView? { self }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let time = CACurrentMediaTime() - animationStart
        drawMessage()
        drawCat(at: catPosition(time: time), phase: time)
    }

    private func catPosition(time: TimeInterval) -> NSPoint {
        let travelWidth = bounds.width + 320
        let x = CGFloat((time * 125).truncatingRemainder(dividingBy: travelWidth)) - 160
        let baseY = max(90, bounds.height * 0.25)
        return NSPoint(x: x, y: baseY + sin(time * 7) * 5)
    }

    private func drawMessage() {
        let title = "休息一下，看看远处"
        let countdown = "胖猫将在 \(remainingSeconds) 秒后让路"
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

    private func drawCat(at position: NSPoint, phase: TimeInterval) {
        NSGraphicsContext.saveGraphicsState()
        let transform = NSAffineTransform()
        transform.translateX(by: position.x, yBy: position.y)
        transform.concat()

        let outline = NSColor(calibratedRed: 0.18, green: 0.14, blue: 0.12, alpha: 1)
        let fur = NSColor(calibratedRed: 0.94, green: 0.58, blue: 0.24, alpha: 1)
        let cream = NSColor(calibratedRed: 1.0, green: 0.86, blue: 0.64, alpha: 1)
        let legSwing = CGFloat(sin(phase * 9)) * 9

        // Tail, behind the body.
        let tail = NSBezierPath()
        tail.move(to: NSPoint(x: 34, y: 68))
        tail.curve(to: NSPoint(x: 1, y: 112), controlPoint1: NSPoint(x: 4, y: 71), controlPoint2: NSPoint(x: -12, y: 98))
        tail.curve(to: NSPoint(x: 20, y: 126), controlPoint1: NSPoint(x: 6, y: 131), controlPoint2: NSPoint(x: 15, y: 133))
        tail.lineWidth = 18
        tail.lineCapStyle = .round
        outline.setStroke(); tail.stroke()
        tail.lineWidth = 12
        fur.setStroke(); tail.stroke()

        // Short walking legs.
        drawLeg(x: 72 + legSwing, color: fur, outline: outline)
        drawLeg(x: 120 - legSwing, color: fur, outline: outline)
        drawLeg(x: 164 + legSwing, color: fur, outline: outline)

        let body = NSBezierPath(ovalIn: NSRect(x: 30, y: 34, width: 160, height: 105))
        outline.setFill(); body.fill()
        let innerBody = NSBezierPath(ovalIn: NSRect(x: 35, y: 39, width: 150, height: 95))
        fur.setFill(); innerBody.fill()

        let belly = NSBezierPath(ovalIn: NSRect(x: 70, y: 43, width: 92, height: 70))
        cream.setFill(); belly.fill()

        // Ears and oversized round head.
        let leftEar = triangle(NSPoint(x: 143, y: 139), NSPoint(x: 154, y: 180), NSPoint(x: 174, y: 146))
        let rightEar = triangle(NSPoint(x: 194, y: 146), NSPoint(x: 216, y: 178), NSPoint(x: 226, y: 136))
        outline.setFill(); leftEar.fill(); rightEar.fill()
        let head = NSBezierPath(ovalIn: NSRect(x: 132, y: 83, width: 105, height: 85))
        outline.setFill(); head.fill()
        let innerHead = NSBezierPath(ovalIn: NSRect(x: 137, y: 88, width: 95, height: 75))
        fur.setFill(); innerHead.fill()

        // Face.
        outline.setFill()
        NSBezierPath(ovalIn: NSRect(x: 162, y: 127, width: 9, height: 12)).fill()
        NSBezierPath(ovalIn: NSRect(x: 202, y: 127, width: 9, height: 12)).fill()
        NSBezierPath(ovalIn: NSRect(x: 183, y: 111, width: 10, height: 7)).fill()
        let muzzle = NSBezierPath()
        muzzle.move(to: NSPoint(x: 188, y: 112))
        muzzle.curve(to: NSPoint(x: 176, y: 104), controlPoint1: NSPoint(x: 186, y: 106), controlPoint2: NSPoint(x: 181, y: 103))
        muzzle.move(to: NSPoint(x: 188, y: 112))
        muzzle.curve(to: NSPoint(x: 200, y: 104), controlPoint1: NSPoint(x: 190, y: 106), controlPoint2: NSPoint(x: 195, y: 103))
        muzzle.lineWidth = 3; muzzle.stroke()

        drawWhiskers(outline: outline)
        NSGraphicsContext.restoreGraphicsState()
    }

    private func drawLeg(x: CGFloat, color: NSColor, outline: NSColor) {
        let outer = NSBezierPath(roundedRect: NSRect(x: x, y: 18, width: 28, height: 43), xRadius: 14, yRadius: 14)
        outline.setFill(); outer.fill()
        let inner = NSBezierPath(roundedRect: NSRect(x: x + 4, y: 22, width: 20, height: 35), xRadius: 10, yRadius: 10)
        color.setFill(); inner.fill()
    }

    private func triangle(_ a: NSPoint, _ b: NSPoint, _ c: NSPoint) -> NSBezierPath {
        let path = NSBezierPath()
        path.move(to: a); path.line(to: b); path.line(to: c); path.close()
        return path
    }

    private func drawWhiskers(outline: NSColor) {
        let whiskers = NSBezierPath()
        whiskers.move(to: NSPoint(x: 174, y: 111)); whiskers.line(to: NSPoint(x: 143, y: 116))
        whiskers.move(to: NSPoint(x: 174, y: 105)); whiskers.line(to: NSPoint(x: 142, y: 101))
        whiskers.move(to: NSPoint(x: 201, y: 111)); whiskers.line(to: NSPoint(x: 232, y: 117))
        whiskers.move(to: NSPoint(x: 201, y: 105)); whiskers.line(to: NSPoint(x: 233, y: 101))
        whiskers.lineWidth = 2.5
        outline.setStroke(); whiskers.stroke()
    }
}
#endif
