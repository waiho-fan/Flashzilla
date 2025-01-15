//
//  FlashzillaApp.swift
//  Flashzilla
//
//  Created by Gary on 14/1/2025.
//

import SwiftData
import SwiftUI

@main
struct FlashzillaApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Card.self)
//            Tutorial()
//            ScenePhaseView()
//            AccessibilityView()
        }
    }
}
