//
//  ViewController.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 16.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pinTitleLabel: UILabel!
    @IBOutlet weak var pinSubmitButton: UIButton!
    @IBOutlet weak var pinTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pinTitleLabel.text = "Enter pin"
    }


    @IBAction func pinSubmitButtonTapped(_ sender: Any) {
        print(self.pinTextField.text!)
    }
    
}

