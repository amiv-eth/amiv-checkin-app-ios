//
//  PopupTableViewCell.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 18.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import UIKit

class PopupTableViewCell: UITableViewCell {

    // MARK: - IB Variables
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: - Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        self.keyLabel.numberOfLines = 0
        self.valueLabel.numberOfLines = 0
        self.keyLabel.textColor = .white
        self.valueLabel.textColor = .white
        self.backgroundColor = .clear
        self.layer.backgroundColor = UIColor.clear.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(_ key: String, value: String) {
        self.keyLabel.text = key
        self.valueLabel.text = value
    }

}
