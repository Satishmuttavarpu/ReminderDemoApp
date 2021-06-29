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

        // Setup trigger time
        let date = reminder.scheduleDate
        let calendar = Calendar.current

        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: date)
        dateComponents.month = calendar.component(.month, from: date)
        dateComponents.day = calendar.component(.day, from: date)
        dateComponents.hour = calendar.component(.hour, from: date)
        dateComponents.minute = calendar.component(.minute, from: date)
        dateComponents.second = calendar.component(.second, from: date) + 2

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let requestID = reminder.id.uriRepresentation().absoluteString
        self.init(identifier: requestID, content: content, trigger: trigger)
    }
}
