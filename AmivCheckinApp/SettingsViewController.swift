//
//  SettingsViewController.swift
//  AmivCheckinApp
//
//  Created by Nicolas Vetsch on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // creating instance of userDefaults
    var userDefaults = CheckinUserDefaults()
    
    @IBOutlet weak var serverURL: UITextField!
    
    @IBOutlet weak var autoRefresh: UISwitch!
    
    @IBOutlet weak var refreshFrequency: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // set up the userDefaults
        serverURL.text = userDefaults.urlAdress
        autoRefresh.isOn = (userDefaults.autoRefresh)
        refreshFrequency.text = String((userDefaults.refreshFrequency))
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignKeyboard))
        self.view.addGestureRecognizer(recognizer)
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        
        if let url = self.serverURL.text, let freq = self.refreshFrequency.text, let frequency = Int(freq) {
            // save settings
            userDefaults.urlAdress = url
            userDefaults.autoRefresh = autoRefresh.isOn
            userDefaults.refreshFrequency = frequency
        }
        
        // exit via segue
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    @objc func resignKeyboard() {
        self.serverURL.resignFirstResponder()
        self.refreshFrequency.resignFirstResponder()
    }
}
