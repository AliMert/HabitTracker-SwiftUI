//
//  HabitsViewModel.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//

import SwiftUI

class HabitsViewModel: ObservableObject {

    @Published var habits: [Habit] = []

    init() {
        CoreDataHabitManager.shared.fetchHabits { [weak self] (habits) in
            self?.habits = habits
        }
    }
}
