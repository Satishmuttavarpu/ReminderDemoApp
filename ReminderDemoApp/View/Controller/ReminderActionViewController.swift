//
//  ReminderActionViewController.swift
//  ReminderDemoApp
//
//  Created by Satish babu  on 29/06/21.
//

import UIKit

enum ReminderAction: String {
    case markIncomplete = "Mark as incomplete"
    case markCompleted = "Mark as complete"
    case delete = "Delete"
    case cancel = "Cancel"
}

protocol ReminderActionSheetDelegate: class {
    func reminderAction(_ action: ReminderAction, _ indexPath: IndexPath)
}

class ReminderActionViewController: UIAlertController {

    weak var delegate: ReminderActionSheetDelegate?

    lazy var markCompleted = UIAlertAction(title: ReminderAction.markCompleted.rawValue, style: .default) { [weak self] action in
        guard let _self = self else { return }
        _self.delegate?.reminderAction(.markCompleted, _self.indexPath)
    }

    lazy var markIncomplete = UIAlertAction(title: ReminderAction.markIncomplete.rawValue, style: .default) { [weak self] action in
        guard let _self = self else { return }
        _self.delegate?.reminderAction(.markIncomplete, _self.indexPath)
    }

    lazy var delete = UIAlertAction(title: ReminderAction.delete.rawValue, style: .destructive) { [weak self] action in
        guard let _self = self else { return }
        _self.delegate?.reminderAction(.delete, _self.indexPath)
    }

    lazy var cancel = UIAlertAction(title: ReminderAction.cancel.rawValue, style: .cancel) { [weak self] action in
        guard let _self = self else { return }
        _self.delegate?.reminderAction(.cancel, _self.indexPath)
    }

    override var preferredStyle: UIAlertController.Style {
        return .actionSheet
    }

    let indexPath: IndexPath

    init(isDone: Bool, for indexPath: IndexPath) {
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
        title = "What would you like to do?"
        if isDone { addAction(markIncomplete) }
        else { addAction(markCompleted) }
        addAction(cancel)
        addAction(delete)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}


