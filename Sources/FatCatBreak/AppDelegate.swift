#if os(macOS)
import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var windows: [BreakWindow] = []
    private var session = BreakSession()
    private var countdownTimer: Timer?
    private var eventMonitor: Any?
    private var breakIsActive = false
    private var previousPresentationOptions: NSApplication.PresentationOptions = []

    func applicationDidFinishLaunching(_ notification: Notification) {
        startBreak()
    }

    private func startBreak() {
        breakIsActive = true
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
            window.makeKeyAndOrderFront(nil)
            return window
        }

        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .keyUp, .flagsChanged]) { _ in nil }
        NSApp.activate(ignoringOtherApps: true)
        updateViews()

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else { return }
            self.session.tick()
            self.updateViews()
            if self.session.isComplete {
                timer.invalidate()
                self.finishBreak()
            }
        }
    }

    private func updateViews() {
        windows.forEach { $0.breakView.remainingSeconds = session.remaining }
    }

    private func finishBreak() {
        breakIsActive = false
        countdownTimer = nil
        if let eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
            self.eventMonitor = nil
        }
        windows.forEach { $0.orderOut(nil) }
        windows.removeAll()
        NSApp.presentationOptions = previousPresentationOptions
        NSApp.terminate(nil)
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        breakIsActive ? .terminateCancel : .terminateNow
    }
}
#endif
