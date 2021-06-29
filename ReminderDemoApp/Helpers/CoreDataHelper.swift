//
//  CoreDataHelper.swift
//  ReminderDemoApp
//
//  Created by Satish babu  on 29/06/21.
//

import CoreData

enum CoreDataEntity: String {
    case Reminder

}

enum ReminderAttribute: String {
    case scheduleDate, isDone, title
}

extension NSManagedObjectContext {

    func getReminders() -> [UserReminder] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntity.Reminder.rawValue)
        do {
            let objects = try self.fetch(fetchRequest)
            let reminders = objects.map { UserReminder($0) }
            return reminders
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
            return []
        }
    }

    func saveReminder(title: String, scheduleDate: Date, isDone: Bool = false) -> UserReminder {
        let entity = NSEntityDescription.entity(forEntityName: CoreDataEntity.Reminder.rawValue, in: self)!
        let object = NSManagedObject(entity: entity, insertInto: self)
        object.setValue(title, forKeyPath: ReminderAttribute.title.rawValue)
        object.setValue(scheduleDate, forKeyPath: ReminderAttribute.scheduleDate.rawValue)
        object.setValue(isDone, forKeyPath: ReminderAttribute.isDone.rawValue)

        do {
            try save()
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
        return UserReminder(object)
    }

    func deleteReminder(_ reminder: UserReminder) {
        let object = self.object(with: reminder.id)
        self.delete(object)
        do {
            try save()
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
    }

    func updateReminder(_ reminder: UserReminder) {
        let object = self.object(with: reminder.id)
        object.setValue(reminder.isDone, forKeyPath: ReminderAttribute.isDone.rawValue)
        do {
            try save()
        } catch {
            print("Could not fetch. \(error), \(error.localizedDescription)")
        }
    }
}
