#if os(macOS)
import AppKit
import ServiceManagement

final class AppDelegate: NSObject, NSApplicationDelegate {
    private let settingsStore = AppSettingsStore()
    private let todoStore = TodoTaskStore()
    private let breakController = BreakController()
    private var mainWindow: NSWindow?
    private var reminderTimer: Timer?
    private var settings = AppSettings.defaults

    func applicationDidFinishLaunching(_ notification: Notification) {
        settings = settingsStore.load()
        configureAppIcon()
        showMainWindow()
        scheduleNextBreak()
    }

    private func showMainWindow() {
        if let mainWindow {
            restoreMainWindow(mainWindow)
            return
        }

        let controller = MainViewController(
            settings: settings,
            onTakeBreakNow: { [weak self] in self?.takeBreakNow() },
            onApplySettings: { [weak self] newSettings in self?.apply(newSettings) },
            onQuit: { NSApp.terminate(nil) }
        )
        let window = NSWindow(contentViewController: controller)
        window.title = "FatCatBreak"
        window.setContentSize(NSSize(width: 1180, height: 780))
        window.minSize = NSSize(width: 980, height: 640)
        window.styleMask = [.titled, .closable, .miniaturizable, .resizable]
        window.isReleasedWhenClosed = false
        window.center()
        mainWindow = window
        restoreMainWindow(window)
    }

    private func restoreMainWindow(_ window: NSWindow) {
        NSApp.unhide(nil)
        if window.isMiniaturized {
            window.deminiaturize(nil)
        }
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func takeBreakNow() {
        mainWindow?.orderOut(nil)
        breakController.start(duration: settings.stayDurationSeconds, highlightedTasks: todayTaskTitles()) { [weak self] in
            if let window = self?.mainWindow {
                self?.restoreMainWindow(window)
            }
            self?.scheduleNextBreak()
        }
    }

    private func apply(_ newSettings: AppSettings) {
        settings = newSettings
        settingsStore.save(newSettings)
        configureLaunchAtLogin(enabled: newSettings.launchAtLogin)
        scheduleNextBreak()
    }

    private func scheduleNextBreak() {
        reminderTimer?.invalidate()
        let interval = settings.triggerIntervalHours * 3600
        reminderTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            self?.takeBreakNow()
        }
    }

    private func configureAppIcon() {
        if let iconURL = Bundle.main.url(forResource: "AppIcon", withExtension: "icns"),
           let iconImage = NSImage(contentsOf: iconURL) {
            NSApp.applicationIconImage = iconImage
        }
    }

    private func todayTaskTitles() -> [String] {
        let today = TodoTaskStore.dateKey(for: Date())
        return todoStore.loadTasks()
            .filter { $0.dueDate == today && !$0.completed }
            .map(\.title)
    }

    private func configureLaunchAtLogin(enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                NSLog("FatCatBreak launch-at-login update failed: \(error.localizedDescription)")
            }
        }
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        breakController.isActive ? .terminateCancel : .terminateNow
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !breakController.isActive {
            showMainWindow()
        }
        return true
    }
}
#endif
