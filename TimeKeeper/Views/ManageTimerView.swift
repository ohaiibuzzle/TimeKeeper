//
//  ManageTimerWindow.swift
//  TimeKeeper
//
//  Created by Venti on 9/3/25.
//

import SwiftUI

struct ManageTimerWindow: View {
    @State var timeHandler = TimeHandler.shared
    @State private var selectedTimer: UUID?

    @State private var newTimerName: String = ""
    @State private var newStartTime: Date = Date()
    @State private var newEndTime: Date = Date()

    var body: some View {
        VStack {
            Table(timeHandler.timers, selection: $selectedTimer) {
                TableColumn("Name") { timer in
                    Text(timer.name)
                }
                TableColumn("Start") { timer in
                    HStack {
                        Text(timer.startTime, style: .date) 
                        Text(timer.startTime, style: .time)
                    }

                }
                TableColumn("End") { timer in
                    HStack {
                        Text(timer.endTime, style: .date)
                        Text(timer.endTime, style: .time)
                    }
                }
            }
            
            HStack {
                // Time and date picker
                HStack {
                    VStack(alignment: .trailing) {
                        DatePicker("Start Time", selection: $newStartTime, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.automatic)
                        DatePicker("End Time", selection: $newEndTime, displayedComponents: [.date, .hourAndMinute])
                    }
                }
                // Add button
                VStack {
                    TextField("Name", text: $newTimerName)
                    HStack {
                        Spacer()
                        Button("Add") {
                            let timer = TimerObject(name: newTimerName, startTime: newStartTime, endTime: newEndTime)
                            timeHandler.addTimer(timer: timer)
                        }
                        .disabled(newTimerName.isEmpty || newStartTime >= newEndTime)
                        
                        // Remove button
                        Button("Remove") {
                            if let selectedTimer = selectedTimer {
                                timeHandler.removeTimer(timer: timeHandler.timers.first { $0.id == selectedTimer }!)
                            }
                        }
                        .disabled(selectedTimer == nil)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

#Preview {
    ManageTimerWindow()
}
