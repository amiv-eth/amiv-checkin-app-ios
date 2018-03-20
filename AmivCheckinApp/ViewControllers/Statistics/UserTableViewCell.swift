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
    
    func config(_ user: User) {
        self.nameLabel.text = user.firstname + " " + user.lastname
        self.legiLabel.text = user.legi
        if user.checked_in {
            self.statusLabel.text = "In"
        } else {
            self.statusLabel.text = "Out"
        }
        self.membershipStatusLabel.text = user.membership.description
    }

}
