//
//  AddReminderViewController.swift
//  ReminderDemoApp
//
//  Created by Satish babu  on 29/06/21.
//

import UIKit
import CoreData
import UserNotifications

class AddReminderViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTimeTextField: UITextField!
    var reminderDate: Date?

    lazy var managedContext: NSManagedObjectContext? = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.persistentContainer.viewContext
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dateTimeTextField.setDatePickerAsInputViewFor(target: self, selector: #selector(dateSelected))
        // Do any additional setup after loading the view.
    }

    @objc func dateSelected() {
        if let datePicker = self.dateTimeTextField.inputView as? UIDatePicker {
            reminderDate = datePicker.date
            self.dateTimeTextField.text = datePicker.date.readableDate
        }
        self.dateTimeTextField.resignFirstResponder()
    }

    @IBAction func addReminderButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, title != "" else {
            titleTextField.becomeFirstResponder()
            return
        }

        guard let _ = dateTimeTextField.text, title != "" else {
            titleTextField.becomeFirstResponder()
            return
        }

        guard let date = reminderDate else {
            return
        }
        guard let nav = parent as? UINavigationController else { fatalError() }
        nav.save(title: title, scheduleDate: date)
        navigationController?.popViewController(animated: true)
    }

}

extension AddReminderViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text != "" else { return false }
        textField.resignFirstResponder()
        return true
    }
}
