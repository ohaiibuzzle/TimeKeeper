//
//  Settings.swift
//  TimeKeeper
//
//  Created by Venti on 9/3/25.
//

import Foundation
import ServiceManagement

@Observable final class Settings {
    static let shared = Settings()
    
    var launchAtStartup: Bool {
        get {
            SMAppService.mainApp.status == .enabled
        }
        set {
            if newValue {
                setItemLaunchAtLogin()
            } else {
                unsetItemLaunchAtLogin()
            }
        }
    }

    private func setItemLaunchAtLogin() {
        do {
            if launchAtStartup == true {
                try? SMAppService.mainApp.unregister()
            }
            try SMAppService.mainApp.register()
        } catch {
            NSLog("Failed to register \(error.localizedDescription).")
        }
    }

    private func unsetItemLaunchAtLogin() {
        do {
            try SMAppService.mainApp.unregister()
        } catch {
            NSLog("Failed to register \(error.localizedDescription).")
        }
    }
}
