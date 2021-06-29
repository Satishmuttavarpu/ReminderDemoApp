//
//  Date-Extension.swift
//  ReminderDemoApp
//
//  Created by Satish babu  on 29/06/21.
//

import Foundation

extension Date {
    var readableDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        return formatter.string(from: self)
    }
}
