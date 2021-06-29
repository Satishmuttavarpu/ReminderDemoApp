//
//  UserReminder.swift
//  ReminderDemoApp
//
//  Created by Satish babu  on 29/06/21.
//

import CoreData

struct UserReminder {

    let id: NSManagedObjectID
    let title: String
    let dueDate: Date
    var isDone: Bool

    init(_ object: NSManagedObject) {
        id = object.objectID
        title = object.value(forKeyPath: ReminderAttribute.title.rawValue) as? String ?? ""
        dueDate = object.value(forKeyPath: ReminderAttribute.dueDate.rawValue) as? Date ?? Date()
        isDone = object.value(forKeyPath: ReminderAttribute.isDone.rawValue) as? Bool ?? false
    }

}
