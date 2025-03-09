//
//  MenuBarView.swift
//  YearProgress
//
//  Created by Venti on 8/3/25.
//

import SwiftUI

struct MenuBarView: View {
    @Environment(\.openWindow) var openWindow

    @State var timeHandler = TimeHandler.shared
    @State var settings = Settings.shared
    @State private var localSelectedTimer: TimerObject = TimerObject(name: "", startTime: Date(), endTime: Date())

    var body: some View {
        VStack(alignment: .leading) {
            // Picker for which timer to use as the status bar text
            Picker("Timers", selection: $localSelectedTimer) {
                ForEach(timeHandler.timers, id: \.self) { t in
                    Text(t.name).tag(t)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: localSelectedTimer) { _, newValue in
                timeHandler.selectedTimer = newValue
            }
            Button("Manage Timers") {
                openWindow(id: "manageTimers")
            }
            .buttonStyle(.plain)
            Divider()
            Toggle("Open at Login", isOn: $settings.launchAtStartup)
            Picker("Display Style", selection: $timeHandler.displayStyle) {
                Text("Duration")
                    .tag(TimeDisplayStyles.duration)
                Text("Percent")
                    .tag(TimeDisplayStyles.percentage)
            }
            .pickerStyle(.menu)
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(self)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .onAppear {
            if let selectedTimer = timeHandler.selectedTimer {
                localSelectedTimer = selectedTimer
            }
        }
    }
}

#Preview {
    MenuBarView()
}
