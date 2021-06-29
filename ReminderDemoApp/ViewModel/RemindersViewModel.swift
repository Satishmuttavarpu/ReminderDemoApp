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
    case reminderDone, reminderPending
}

class RemindersViewModel {

    fileprivate var reminders: [UserReminder] = []
    var filteredreminders: [UserReminder] = []
    fileprivate var filter: Filter = .reminderPending


    lazy var managedContext: NSManagedObjectContext? = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.persistentContainer.viewContext
    }()

    func reminder(at indexPath: IndexPath) -> UserReminder {
        return filteredreminders[indexPath.row]
    }

    func delete(at indexPath: IndexPath) {
        let deletedReminder = filteredreminders[indexPath.row]
        deleteObject(deletedReminder)
        filteredreminders.remove(at: indexPath.row)
        if let index = reminders.firstIndex(where: { $0.id == deletedReminder.id }) {
            reminders.remove(at: index)
        }
    }

    func update(at indexPath: IndexPath, isDone: Bool) {
        filteredreminders[indexPath.row].isDone = isDone
        update(filteredreminders[indexPath.row])
        if let index = reminders.firstIndex(where: { $0.id == filteredreminders[indexPath.row].id }) {
            reminders[index].isDone = isDone
        }
        applyFilter(filter)
    }

    func applyFilter(_ filter: Filter) {
        self.filter = filter
        switch filter {
        case .reminderDone:
            filteredreminders = reminders.filter { $0.isDone }
        case .reminderPending:
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

    func save(title: String, scheduleDate: Date, isDone: Bool = false) {
        let reminder = managedContext?.saveReminder(title: title, scheduleDate: scheduleDate, isDone: isDone)
        guard let r = reminder else { return }
        setLocalPushNotification(r)
        reminders.append(r)
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
