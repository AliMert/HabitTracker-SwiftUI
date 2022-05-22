//
//  AddHabitViewModel.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//
import SwiftUI
import CoreData
import UserNotifications

final class AddHabitViewModel: ObservableObject {

    // MARK:  Habit Properties

    @Published var title: String
    @Published var habitColor: String
    @Published var weekdays: [String]
    @Published var isReminderOn: Bool
    @Published var reminderText: String
    @Published var reminderDate: Date

    // MARK: Reminder Time Picker
    @Published var showTimePicker: Bool = false

    // MARK: Editing Habit
    @Published var editHabit: Habit?

    // MARK: Notification Access Status
    @Published var notificationAccess: Bool = false

    // MARK: Init
    init(editHabit: Habit? = nil) {
        self.editHabit = editHabit
        self.title = editHabit?.title ?? ""
        self.habitColor = editHabit?.color ?? "Card-1"
        self.weekdays = editHabit?.weekdays ?? []
        self.isReminderOn = editHabit?.isReminderOn ?? false
        self.reminderText = editHabit?.reminderText ?? ""
        self.reminderDate = editHabit?.notificationDate ?? Date()

        requestNotificationAccess()
    }


    // MARK: Done Button Status
    func doneStatus() -> Bool {
        let reminderStatus = isReminderOn ? reminderText == "" : false

        if title == "" || weekdays.isEmpty || reminderStatus {
            return false
        }
        return true
    }

    func requestNotificationAccess() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { [weak self] (status, _) in
            DispatchQueue.main.async {
                self?.notificationAccess = status
            }
        }
    }

    private func getCurrentRowId() -> Int64? {
        let request = Habit.fetchRequest()
        // filter the maximum rowID
        request.predicate = NSPredicate(format: "rowID==max(rowID)")
        request.fetchLimit = 1

        do {
            let habits = try CoreDataHabitManager.context.fetch(request)
            if let id = habits.first?.rowID {
                return id + 1
            } else {
                return 1
            }
        } catch {
            print(error.localizedDescription)
        }

        return nil
    }

    // MARK: Inserting/Updating Habit to Database
    func upsertHabbit(context: NSManagedObjectContext) -> Bool {
        guard let rowID = getCurrentRowId() else {
            return false
        }

        let habit = editHabit ?? Habit(context: context)
        habit.title = title
        habit.color = habitColor
        habit.weekdays = weekdays
        habit.isReminderOn = isReminderOn
        habit.reminderText = reminderText
        habit.notificationDate = reminderDate
        habit.dateAdded = editHabit?.dateAdded ?? Date()
        habit.dateUpdated = Date()
        habit.notificationIDs = editHabit?.notificationIDs ?? []
        habit.rowID = editHabit?.rowID ?? rowID

        if let notificationIDs = editHabit?.notificationIDs,
           !notificationIDs.isEmpty {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIDs)
        }

        if isReminderOn {
            // MARK: Scheduling Notifications
            let notificationIDs = scheduleNotificationAndGetIDs()
            habit.notificationIDs = notificationIDs

            if CoreDataHabitManager.save(to: context) {
                return true
            } else {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: notificationIDs)
                return false
            }
        }

        return CoreDataHabitManager.save(to: context)
    }

    // MARK: Adding Notifications
    private func scheduleNotificationAndGetIDs() -> [String] {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Habit Tracker"
        notificationContent.subtitle = reminderText
        notificationContent.sound = UNNotificationSound.default

        // Scheduled Ids
        var notificationIDs: [String] = []
        let calendar = Calendar.current
        let weekdaySymbols: [String] = calendar.weekdaySymbols

        // MARK: Scheduling Notification
        for day in weekdays {
            guard let index = weekdaySymbols.firstIndex(where: { $0 == day }) else {
                return notificationIDs
            }

            // UNIQUE ID FOR EACH NOTIFICATION
            let id = UUID().uuidString
            let hour = calendar.component(.hour, from: reminderDate)
            let min = calendar.component(.minute, from: reminderDate)

            // MARK: Since Week Day Starts from 1-7
            // Thus Adding +1 to Index
            var components = DateComponents()
            components.hour = hour
            components.minute = min
            components.weekday = index + 1

            // MARK: Trigger Notification on Each Selected Day
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

            // MARK: Notification Request
            let request = UNNotificationRequest(identifier: id, content: notificationContent, trigger: trigger)

            // ADDING ID
            notificationIDs.append(id)

            UNUserNotificationCenter.current().add(request)
        }

        return notificationIDs
    }
}
