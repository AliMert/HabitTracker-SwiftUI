//
//  CoreDataHabitManager.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//

import Foundation
import CoreData

class CoreDataHabitManager: ObservableObject {
    private let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "HabitTracker")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error Loading Core Data: \(error)")
            }
        }
    }

    func fetchHabits(completion: ([Habit])->Void) {
        let request = NSFetchRequest<Habit>(entityName: Habit.description())
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Habit.dateAdded, ascending: false)]

        do {
            let habits = try container.viewContext.fetch(request)
            completion(habits)
        } catch let error {
            print("Error fetching: \(error)")
        }
    }
}
