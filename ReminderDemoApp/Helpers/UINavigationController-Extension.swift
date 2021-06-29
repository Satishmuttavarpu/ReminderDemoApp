//
//  UINavigationController-Extension.swift
//  ReminderDemoApp
//
//  Created by Satish babu  on 29/06/21.
//

import UIKit

extension UINavigationController {

    func save(title: String, scheduleDate: Date) {
        for i in children {
            if let vc = i as? ViewController {
                vc.save(title: title, scheduleDate: scheduleDate)
            }
        }
    }
}
