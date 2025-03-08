//
//  TimeKeeperApp.swift
//  TimeKeeper
//
//  Created by Venti on 8/3/25.
//

import SwiftUI

@main
struct TimeKeeperApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State var statusBarStates = StatusBarStates.shared
    @State var timeHandler = TimeHandler.shared

    var body: some Scene {
        WindowGroup(id: "manageTimers") {
            ManageTimerWindow()
        }
        .defaultLaunchBehavior(.suppressed)
        .windowResizability(.contentSize)
        MenuBarExtra()  {
            MenuBarView()
        } label: {
            Text(statusBarStates.statusText)
        }
        .menuBarExtraStyle(.menu)
    }

    // On startup, start ticking 
    init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            TimeHandler.shared.tick()
        }
    }
}

// App Delegate to save timers when the app about to terminate
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        TimeHandler.shared.saveTimers()
        return .terminateNow
    }

    func updateActivationPolicy(to policy: NSApplication.ActivationPolicy) {
            NSApp.setActivationPolicy(policy)
            NSApp.activate(ignoringOtherApps: true)
    }
}