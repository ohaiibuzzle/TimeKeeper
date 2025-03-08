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

enum TimeDisplayStyles: String {
    case duration
    case percentage
}

@Observable class TimeHandler {
    static let shared = TimeHandler()

    private init() {
        // Add the rest
        if let data = UserDefaults.standard.data(forKey: "timers") {
            let decoded = try! JSONDecoder().decode([TimerObject].self, from: data)
            timers = decoded
        }

        let timerUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000") // Special static UUID
        let currentYear = Calendar.current.component(.year, from: Date())
        let jan1 = Calendar.current.date(from: DateComponents(year: currentYear, month: 1, day: 1))!
        let jan1NextYear = Calendar.current.date(from: DateComponents(year: currentYear + 1, month: 1, day: 1))!
        let timer = TimerObject(id: timerUUID!, name: "\(currentYear)", startTime: jan1, endTime: jan1NextYear)
        addTimer(timer: timer)
    }

    var timers: [TimerObject] = []
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
        timers.append(timer)
        saveTimers()
    }

    func removeTimer(timer: TimerObject) {
        if timer.id == UUID(uuidString: "00000000-0000-0000-0000-000000000000") {
            return
        }
        timers.removeAll { $0.id == timer.id }
        if selectedTimer?.id == timer.id {
            selectedTimer = nil
        }
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
                removeTimer(timer: timer)
            }
        }
    }

    func saveTimers() {
        // Remove the yearly timer
        let saveTimers = timers.filter { $0.id != UUID(uuidString: "00000000-0000-0000-0000-000000000000") }
        let data = try! JSONEncoder().encode(saveTimers)
        UserDefaults.standard.set(data, forKey: "timers")
    }
}
