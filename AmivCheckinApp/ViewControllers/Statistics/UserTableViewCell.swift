//
//  UserTableViewCell.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import UIKit

/**
 
 Class for user cells
 
 */
class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var legiLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var membershipStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(_ user: User, counting: Bool) {
        self.nameLabel.text = user.firstname + " " + user.lastname
        self.legiLabel.text = user.legi
        if counting {
            self.statusLabel.text = "\(user.checkin_count)"
        } else if user.checked_in {
            self.statusLabel.text = "In"
        } else {
            self.statusLabel.text = "Out"
        }
        self.membershipStatusLabel.text = user.membership.description
    }

}
