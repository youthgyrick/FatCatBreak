import Foundation

struct AppSettings: Equatable {
    var triggerIntervalHours: Double
    var stayDurationSeconds: Int
    var launchAtLogin: Bool

    static let defaults = AppSettings(triggerIntervalHours: 1.5, stayDurationSeconds: BreakSession.defaultDuration, launchAtLogin: false)
}

struct AppSettingsStore {
    private let defaults: UserDefaults
    private let intervalKey = "FatCatBreak.settings.triggerIntervalHours"
    private let durationKey = "FatCatBreak.settings.stayDurationSeconds"
    private let loginKey = "FatCatBreak.settings.launchAtLogin"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> AppSettings {
        let interval = defaults.object(forKey: intervalKey) as? Double ?? AppSettings.defaults.triggerIntervalHours
        let duration = defaults.object(forKey: durationKey) as? Int ?? AppSettings.defaults.stayDurationSeconds
        let login = defaults.bool(forKey: loginKey)
        return AppSettings(
            triggerIntervalHours: Self.clampInterval(interval),
            stayDurationSeconds: Self.clampDuration(duration),
            launchAtLogin: login
        )
    }

    func save(_ settings: AppSettings) {
        defaults.set(Self.clampInterval(settings.triggerIntervalHours), forKey: intervalKey)
        defaults.set(Self.clampDuration(settings.stayDurationSeconds), forKey: durationKey)
        defaults.set(settings.launchAtLogin, forKey: loginKey)
    }

    static func clampInterval(_ value: Double) -> Double { min(168, max(0.1, value)) }
    static func clampDuration(_ value: Int) -> Int { min(600, max(1, value)) }
}
