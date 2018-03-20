//
//  StatisticsTableViewCell.swift
//  AmivCheckinApp
//
//  Created by Nicolas Vetsch on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import UIKit

/**
 
 Class for stats cells
 
 */
class StatisticsTableViewCell: UITableViewCell {

    // MARK: - IB Variables
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: - Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(_ statistic: Statistics) {
        self.keyLabel.text = statistic.key
        self.valueLabel.text = String(describing: statistic.value)
    }

}
