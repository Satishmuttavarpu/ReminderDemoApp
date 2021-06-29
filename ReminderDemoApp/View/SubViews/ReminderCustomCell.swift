//
//  ReminderCustomCell.swift
//  ReminderDemoApp
//
//  Created by Satish babu  on 29/06/21.
//

import UIKit

class ReminderCustomCell: UITableViewCell {

    @IBOutlet weak var userTitle: UILabel!
    @IBOutlet weak var userDate: UILabel!
    @IBOutlet weak var userDone: UIImageView!
    @IBOutlet weak var containerView: UIView! {
        didSet {
            // Make it card-like
            containerView.layer.cornerRadius = 10
            containerView.layer.shadowOpacity = 0.5
            containerView.layer.shadowRadius = 0.5
            containerView.layer.shadowColor = UIColor.white.cgColor
            containerView.layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(_ reminder: UserReminder) {
        userTitle?.text = reminder.title
        userDate?.text = reminder.scheduleDate.readableDate
        if reminder.isDone {
            userDone.image = UIImage(#imageLiteral(resourceName: "check"))
        } else {
            userDone.image = UIImage(#imageLiteral(resourceName: "uncheck"))
        }
    }

}
