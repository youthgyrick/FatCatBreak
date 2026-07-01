#if os(macOS)
import AppKit

final class BreakController {
    private var windows: [BreakWindow] = []
    private var session = BreakSession()
    private var countdownTimer: Timer?
    private var eventMonitor: Any?
    private var completionHandler: (() -> Void)?
    private var previousPresentationOptions: NSApplication.PresentationOptions = []
    private(set) var isActive = false

    func start(duration: Int, highlightedTasks: [String] = [], completion: (() -> Void)? = nil) {
        guard !isActive else { return }
        isActive = true
        completionHandler = completion
        session = BreakSession(duration: duration)
        previousPresentationOptions = NSApp.presentationOptions
        NSApp.presentationOptions = [
            .hideDock,
            .hideMenuBar,
            .disableAppleMenu,
            .disableProcessSwitching,
            .disableForceQuit,
            .disableSessionTermination,
            .disableHideApplication
        ]

        windows = NSScreen.screens.map { screen in
            let window = BreakWindow(screen: screen)
            window.breakView.remainingSeconds = session.remaining
            window.breakView.highlightedTasks = highlightedTasks
            window.makeKeyAndOrderFront(nil)
            return window
        }

        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .keyUp, .flagsChanged]) { [weak self] event in
            guard let self else { return nil }
            if event.type == .keyDown, event.keyCode == 53 {
                self.endBreak()
            }
            return nil
        }
        NSApp.activate(ignoringOtherApps: true)

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            self.session.tick()
            self.windows.forEach { $0.breakView.remainingSeconds = self.session.remaining }
            if self.session.isComplete {
                timer.invalidate()
                self.endBreak()
            }
        }
    }

    private func endBreak() {
        guard isActive else { return }
        let completion = completionHandler
        completionHandler = nil
        finish()
        completion?()
    }

    func finish() {
        guard isActive else { return }
        isActive = false
        countdownTimer?.invalidate()
        countdownTimer = nil
        completionHandler = nil
        if let eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
            self.eventMonitor = nil
        }
        windows.forEach { $0.orderOut(nil) }
        windows.removeAll()
        NSApp.presentationOptions = previousPresentationOptions
    }
}
#endif
