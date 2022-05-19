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
    @Published var weekDays: [String] = []
    @Published var isReminderOn: Bool = false
    @Published var reminderText: String = ""
    @Published var reminderDate: Date = Date()

    // MARK: Reminder Time Picker
    @Published var showTimePicker: Bool = false

    // MARK: Editing Habit
    @Published var editHabit: Habit?

    // MARK: Notification Access Status
    @Published var notificationAccess: Bool = false
}
