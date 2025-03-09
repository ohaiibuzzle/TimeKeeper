//
//  TimeHandler.swift
//  TimeKeeper
//
//  Created by Venti on 8/3/25.
//

import Foundation

struct TimerObject: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var startTime: Date
    var endTime: Date

    func timeLeft() -> Double {
        let total = endTime.timeIntervalSince(startTime)
        let elapsed = Date().timeIntervalSince(startTime)
        return total - elapsed
    }

    func computePercent() -> Double {
        let total = endTime.timeIntervalSince(startTime)
        let elapsed = Date().timeIntervalSince(startTime)
        return elapsed / total * 100
    }

    func getHumanReadableTime() -> String {
        let timeLeft = timeLeft()
        let days = Int(timeLeft / 86400)
        let hours = Int((timeLeft.truncatingRemainder(dividingBy: 86400)) / 3600)
        let minutes = Int((timeLeft.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(timeLeft.truncatingRemainder(dividingBy: 60))
        return String("\(days):\(hours):\(minutes):\(seconds) left of \(name)")
    }

    func getHumanReadablePercent() -> String {
        let percent = computePercent()
        return String("\(String(format: "%.2f", percent))% of \(name)")
    }
}

@Observable class TimeHandler {
    static let shared = TimeHandler()

    private init() {
        // Add the rest
        if let timers = UserDefaults.standard.data(forKey: "timers") {
            if let decodedTimers = try? JSONDecoder().decode([TimerObject].self, from: timers) {
                userTimers = decodedTimers
            }
        }

        // Add transparent timers
        resetTransparentTimers()
    }

    private func resetTransparentTimers() {
        var newTransparentTimers = [TimerObject]()
        newTransparentTimers.append(createYearlyTimer())
        newTransparentTimers.append(createMonthlyTimer())
        newTransparentTimers.append(createWeeklyTimer())
        newTransparentTimers.append(createDailyTimer())
        
        transparentTimers = newTransparentTimers
    }

    private var transparentTimers: [TimerObject] = []
    private var userTimers: [TimerObject] = []

    var timers: [TimerObject] {
        get {
            return userTimers + transparentTimers
        }
        set {
            userTimers = newValue
            saveTimers()
        }
    }

    var selectedTimer: TimerObject? {
        get {
            let uuidString = UserDefaults.standard.string(forKey: "selectedTimer")
            guard let uuid = UUID(uuidString: uuidString ?? "") else { return nil }
            return timers.first { $0.id == uuid }
        }
        set {
            UserDefaults.standard.set(newValue?.id.uuidString, forKey: "selectedTimer")
        }
    }
    var displayStyle: TimeDisplayStyles {
        get {
            guard let rawValue = UserDefaults.standard.string(forKey: "displayStyle") else { return .duration }
            return TimeDisplayStyles(rawValue: rawValue) ?? .percentage
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "displayStyle")
        }
    }

    func addTimer(timer: TimerObject) {
        userTimers.append(timer)
        saveTimers()
    }

    func removeTimer(timer: TimerObject) {
        userTimers.removeAll { $0.id == timer.id }
        saveTimers()
    }

    func tick() {
        if let selectedTimer = selectedTimer {
            StatusBarStates.shared.statusText = displayStyle == .duration ?
            selectedTimer.getHumanReadableTime() :
            selectedTimer.getHumanReadablePercent()
        } else {
            if timers.isEmpty {
                StatusBarStates.shared.statusText = "No timers"
            }
            selectedTimer = timers.first
        }

        for timer in timers {
            if timer.timeLeft() <= 0 {
                // If the timer is in the Transparent timer group, reset the whole group instead
                if transparentTimers.contains(timer) {
                    resetTransparentTimers()
                    return
                }
                removeTimer(timer: timer)
            }
        }
    }

    func saveTimers() {
        // Only save user timers
        let data = try! JSONEncoder().encode(userTimers)
        UserDefaults.standard.set(data, forKey: "timers")
    }
}
