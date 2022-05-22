//
//  HabitTrackerApp.swift
//  Shared
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//

import SwiftUI

@main
struct HabitTrackerApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, CoreDataHabitManager.context)
        }
    }
}
