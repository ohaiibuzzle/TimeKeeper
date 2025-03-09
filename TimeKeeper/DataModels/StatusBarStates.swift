//
//  StatusBarStates.swift
//  TimeKeeper
//
//  Created by Venti on 8/3/25.
//

import SwiftUI

@Observable class StatusBarStates {
    static let shared = StatusBarStates()

    var statusText: String = "Empty"
    var showWindow: Bool = false
}
