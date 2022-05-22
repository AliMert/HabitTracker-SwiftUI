//
//  CoreDataHabitManager.swift
//  HabitTracker
//
//  Created by Ali Mert Özhayta on 19.05.2022.
//

import CoreData

struct CoreDataHabitManager {
    static let shared = CoreDataHabitManager()

    let container: NSPersistentContainer

    static var context: NSManagedObjectContext {
        shared.container.viewContext
    }

    static var preview: CoreDataHabitManager = {
        let result = CoreDataHabitManager(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 1..<5 {
            let habit = Habit(context: viewContext)
            habit.rowID = Int64(i)
            habit.color = "Card-\(i)"
            habit.title = "Workout-\(i)"
            var weekdays = [String]()

            for randomDayCount in 0...Int.random(in: 0..<7) {
                let day = Calendar.current.weekdaySymbols.randomElement()
                ?? Calendar.current.weekdaySymbols[randomDayCount]
                weekdays.append(day)
            }
            habit.weekdays = weekdays
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()


    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "HabitTracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    @discardableResult
    static func delete(_ object: NSManagedObject, from context: NSManagedObjectContext) -> Bool {
        context.delete(object)
        return CoreDataHabitManager.save(to: context)
    }

    @discardableResult
    static func save(to context: NSManagedObjectContext) -> Bool {
        do {
            try context.save()
            return true
        } catch let error {
            print(error)
            return false
        }
    }
}
