//
//  HabitsViewModel.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//

import SwiftUI

class HabitsViewModel: ObservableObject {

    @EnvironmentObject var coreDataHabitManager: CoreDataHabitManager
    @Published var habits: [Habit] = []

    init() {
        coreDataHabitManager.fetchHabits { [weak self] (habits) in
            self?.habits = habits
        }
    }
}
