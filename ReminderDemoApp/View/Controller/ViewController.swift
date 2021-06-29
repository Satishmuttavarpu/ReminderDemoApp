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



    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchFromCoreData()
        // Do any additional setup after loading the view.
    }

    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.applyFilter(.pending)
        case 1:
            viewModel.applyFilter(.completed)
        default:
            fatalError()
        }
        tableView.reloadData()
    }


}

