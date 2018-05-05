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

    // MARK: - IB Variables
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var legiLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var membershipStatusLabel: UILabel!
    
    // MARK: - Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(_ user: User) {
        self.nameLabel.text = user.firstname + " " + user.lastname
        self.legiLabel.text = user.legi
        if let checkin = user.checked_in {
            self.statusLabel.text = checkin ? "In" : "Out"
        } else if let freebee = user.freebies_taken {
            self.statusLabel.text = String(describing: freebee)
        }
        self.membershipStatusLabel.text = user.membership.description
    }

}
