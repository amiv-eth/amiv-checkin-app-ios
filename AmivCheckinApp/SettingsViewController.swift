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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        // save settings
        userDefaults.urlAdress = serverURL.text!
        userDefaults.autoRefresh = autoRefresh.isOn
        userDefaults.refreshFrequency = Float(refreshFrequency.text!)!
        
        // exit via segue
        self.performSegue(withIdentifier: "unwindToMain", sender: self)
    }
}
