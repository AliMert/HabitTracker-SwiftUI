//
//  AddHabitViewModel.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//

import Foundation

final class AddHabitViewModel: ObservableObject {
    // MARK: New Habit Properties

    @Published var title: String = ""
    @Published var habitColor: String = "Card-1"
    @Published var weekdays: [String] = []
    @Published var isReminderOn: Bool = false
    @Published var reminderText: String = ""
    @Published var reminderDate: Date = Date()

    // MARK: Reminder Time Picker
    @Published var showTimePicker: Bool = false

    // MARK: Editing Habit
    @Published var editHabit: Habit?

    // MARK: Notification Access Status
    @Published var notificationAccess: Bool = false

    // MARK: Adding Habit to Database
    func addHabbit() -> Bool {

        let habit = Habit(context: CoreDataHabitManager.shared.context)
        habit.title = title
        habit.color = habitColor
        habit.weekdays = weekdays
        habit.isReminderOn = isReminderOn
        habit.reminderText = reminderText
        habit.notificationDate = reminderDate
        habit.dateAdded = Date()
        habit.notificationIDs = []

        return CoreDataHabitManager.shared.save()
    }

    // MARK: Done Button Status
    func doneStatus() -> Bool {
        let reminderStatus = isReminderOn ? reminderText == "" : false

        if title == "" || weekdays.isEmpty || reminderStatus {
            return false
        }
        return true
    }
}
