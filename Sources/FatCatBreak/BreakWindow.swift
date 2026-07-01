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
            defer: false
        )
        configure(for: screen)
    }

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        breakView = BreakView(frame: NSRect(origin: .zero, size: contentRect.size))
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        configure(for: nil)
    }

    private func configure(for screen: NSScreen?) {
        if let screen {
            breakView.frame = NSRect(origin: .zero, size: screen.frame.size)
            setFrame(screen.frame, display: true)
        } else {
            breakView.frame = NSRect(origin: .zero, size: frame.size)
        }
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
