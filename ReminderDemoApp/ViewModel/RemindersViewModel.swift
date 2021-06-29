//
//  RemindersViewModel.swift
//  ReminderDemoApp
//
//  Created by Satish babu  on 29/06/21.
//

import UIKit
import CoreData
import UserNotifications

enum Filter {
    case completed, pending
}

class RemindersViewModel {

    fileprivate var reminders: [UserReminder] = []
    fileprivate var filteredreminders: [UserReminder] = []
    fileprivate var filter: Filter = .pending


    lazy var managedContext: NSManagedObjectContext? = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.persistentContainer.viewContext
    }()

    func task(at indexPath: IndexPath) -> UserReminder {
        return filteredreminders[indexPath.row]
    }

    func delete(at indexPath: IndexPath) {
        let deletedTask = filteredreminders[indexPath.row]
       // deleteObject(deletedTask)
        filteredreminders.remove(at: indexPath.row)
        if let index = reminders.firstIndex(where: { $0.id == deletedTask.id }) {
            reminders.remove(at: index)
        }
    }

    func update(at indexPath: IndexPath, isCompleted: Bool) {
        filteredreminders[indexPath.row].isDone = isCompleted
        //update(filteredreminders[indexPath.row])
        if let index = reminders.firstIndex(where: { $0.id == filteredreminders[indexPath.row].id }) {
            reminders[index].isDone = isCompleted
        }
        applyFilter(filter)
    }

    func applyFilter(_ filter: Filter) {
        self.filter = filter
        switch filter {
        case .completed:
            filteredreminders = reminders.filter { $0.isDone }
        case .pending:
            filteredreminders = reminders.filter { !$0.isDone }
        }
    }
}

//MARK:- Core Data
extension RemindersViewModel {

     func fetchFromCoreData() {
        reminders = managedContext?.getReminders() ?? []
        applyFilter(filter)
    }

    func save(title: String, dueDate: Date, isDone: Bool = false) {
        let task = managedContext?.saveReminder(title: title, dueDate: dueDate, isDone: isDone)
        guard let t = task else { return }
        setLocalPushNotification(t)

        reminders.append(t)
        applyFilter(filter)
    }

    fileprivate func setLocalPushNotification(_ reminder: UserReminder) {
        let request = UNNotificationRequest(reminder: reminder)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    fileprivate func deleteObject(_ reminder: UserReminder) {
        let id = reminder.id.uriRepresentation().absoluteString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        managedContext?.deleteReminder(reminder)
    }

    fileprivate func update(_ reminder: UserReminder) {
        managedContext?.updateReminder(reminder)
        if reminder.isDone {
            let id = reminder.id.uriRepresentation().absoluteString
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        }
    }

}
