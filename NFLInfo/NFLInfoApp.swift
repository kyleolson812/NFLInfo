//
//  NFLInfoApp.swift
//  NFLInfo
//
//  Created by Kyle Olson on 7/17/23.
//

import SwiftUI
import SwiftData

@main
struct NFLInfoApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabbedView()
        }
        .modelContainer(for: [Team.self, Player.self])
    }
}
