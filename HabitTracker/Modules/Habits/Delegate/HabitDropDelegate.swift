//
//  HabitDropDelegate.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 22.05.2022.
//

import SwiftUI

struct HabitDropDelegate : DropDelegate {
    private let habit : Habit
    @Binding private var draggedHabit : Habit?
    @Environment(\.managedObjectContext) private var context

    init(draggedHabit: Binding<Habit?>, habit: Habit) {
        self.habit = habit
        self._draggedHabit = draggedHabit
    }

    func performDrop(info: DropInfo) -> Bool {
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggedHabit = self.draggedHabit else {
            return
        }

        if draggedHabit != habit {
            let rowID = draggedHabit.rowID
            draggedHabit.rowID = habit.rowID
            habit.rowID = rowID
            CoreDataHabitManager.save(to: context)
        }
    }
}
