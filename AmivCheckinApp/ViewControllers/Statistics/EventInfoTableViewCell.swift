//
//  EventInfoTableViewCell.swift
//  AmivCheckinApp
//
//  Created by Nicolas Vetsch on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import UIKit

/**
 
 Class for event info cells
 
 */
class EventInfoTableViewCell: UITableViewCell {

    // MARK: - IB Variables
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: - Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config(_ key: String, value: String) {
        self.keyLabel.text = key
        self.valueLabel.text = value
    }
}
