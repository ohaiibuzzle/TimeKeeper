//
//  TimeUtils.swift
//  TimeKeeper
//
//  Created by Venti on 9/3/25.
//

import Foundation

enum TimeDisplayStyles: String {
    case duration
    case percentage
}


func createYearlyTimer() -> TimerObject {
    let specialUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
    let currentYear = Calendar.current.component(.year, from: Date())
    let jan1 = Calendar.current.date(from: DateComponents(year: currentYear, month: 1, day: 1))!
    let jan1NextYearMinusOneSecond = Calendar.current.date(from: DateComponents(year: currentYear + 1, month: 1, day: 1))!.addingTimeInterval(-1)
    let timer = TimerObject(id: specialUUID, name: "\(currentYear)", startTime: jan1, endTime: jan1NextYearMinusOneSecond)
    return timer
}

func createMonthlyTimer() -> TimerObject {
    // 1st day of current month -> 1st day of next month
    let specialUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    let currentMonth = Calendar.current.component(.month, from: Date())
    let firstDayOfMonth = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: currentMonth, day: 1))!
    let lastDayOfMonth = Calendar.current.date(byAdding: .month, value: 1, to: firstDayOfMonth)!.addingTimeInterval(-1)
    let timer = TimerObject(id: specialUUID, name: "Month", startTime: firstDayOfMonth, endTime: lastDayOfMonth)
    return timer
}

func createWeeklyTimer() -> TimerObject {
    let specialUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
    let currentWeek = Calendar.current.component(.weekOfYear, from: Date())
    let firstDayOfWeek = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), weekday: 1, weekOfYear: currentWeek))!
    let lastDayOfWeek = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: firstDayOfWeek)!.addingTimeInterval(-1)
    let timer = TimerObject(id: specialUUID, name: "Week", startTime: firstDayOfWeek, endTime: lastDayOfWeek)
    return timer
}

func createDailyTimer() -> TimerObject {
    let specialUUID = UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
    let beginningOfDay = Calendar.current.startOfDay(for: Date())
    let timer = TimerObject(id: specialUUID, name: "Today", startTime: beginningOfDay, endTime: beginningOfDay.addingTimeInterval(86400))

    return timer
}
