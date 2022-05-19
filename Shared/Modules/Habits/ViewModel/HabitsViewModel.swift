//
//  HabitsViewModel.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//

import SwiftUI

class HabitsViewModel: ObservableObject {

    @FetchRequest(
        entity: Habit.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Habit.dateAdded, ascending: false)],
        predicate: nil,
        animation: .easeInOut
    ) var habits: FetchedResults<Habit>

}

