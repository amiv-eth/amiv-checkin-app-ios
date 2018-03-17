//
//  EventInfoTableViewCell.swift
//  AmivCheckinApp
//
//  Created by Nicolas Vetsch on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import UIKit

class EventInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        self.keyLabel.numberOfLines = 0
    }

    func config(_ key: String, value: String) {
        self.keyLabel.text = key
        self.valueLabel.text = value
    }
}
