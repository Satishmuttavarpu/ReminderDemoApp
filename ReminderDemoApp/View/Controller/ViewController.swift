//
//  ViewController.swift
//  ReminderDemoApp
//
//  Created by Satish babu  on 29/06/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let viewModel = RemindersViewModel()
    fileprivate let cellID = "reminderCell"



    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchFromCoreData()
        // Do any additional setup after loading the view.
    }

    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.applyFilter(.reminderPending)
        case 1:
            viewModel.applyFilter(.reminderDone)
        default:
            fatalError()
        }
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredreminders.count
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ReminderCustomCell else { return UITableViewCell() }
        let reminder = viewModel.filteredreminders[indexPath.row]
        cell.configureCell(reminder)
        return cell
    }

}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reminder = viewModel.reminder(at: indexPath)
        let alert = ReminderActionViewController(isDone: reminder.isDone, for: indexPath)
        alert.delegate = self
        present(alert, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            viewModel.delete(at: indexPath)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension ViewController {

    func save(title: String, scheduleDate: Date) {
        viewModel.save(title: title, scheduleDate: scheduleDate)
        tableView.reloadData()
    }
}

extension ViewController: ReminderActionSheetDelegate {
    func reminderAction(_ action: ReminderAction, _ indexPath: IndexPath) {
        switch action {
        case .markCompleted:
            viewModel.update(at: indexPath, isDone: true)
        case .markIncomplete:
            viewModel.update(at: indexPath, isDone: false)
        case .delete:
            viewModel.delete(at: indexPath)
        case .cancel:
            return
        }
        tableView.reloadData()
    }
}

