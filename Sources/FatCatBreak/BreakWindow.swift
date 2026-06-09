#if os(macOS)
import AppKit

final class BreakWindow: NSWindow {
    let breakView: BreakView

    init(screen: NSScreen) {
        breakView = BreakView(frame: NSRect(origin: .zero, size: screen.frame.size))
        super.init(
            contentRect: screen.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false,
            screen: screen
        )

        setFrame(screen.frame, display: true)
        level = .screenSaver
        backgroundColor = .clear
        isOpaque = false
        hasShadow = false
        ignoresMouseEvents = false
        acceptsMouseMovedEvents = true
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        contentView = breakView
    }

    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}
#endif
