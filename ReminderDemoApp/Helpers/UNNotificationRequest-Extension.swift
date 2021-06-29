//
//  UNNotificationRequest-Extension.swift
//  ReminderDemoApp
//
//  Created by Satish babu  on 29/06/21.
//

import UserNotifications

extension UNNotificationRequest {

    convenience init(reminder: UserReminder) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder Alert"
        content.body = reminder.title
        content.badge = 1
        content.sound = UNNotificationSound.default

        let timeInterval = reminder.dueDate.timeIntervalSince1970 - Date().timeIntervalSince1970
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let requestID = reminder.id.uriRepresentation().absoluteString
        self.init(identifier: requestID, content: content, trigger: trigger)
    }
}
