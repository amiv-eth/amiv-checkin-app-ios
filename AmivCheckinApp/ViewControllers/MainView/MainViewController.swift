//
//  MainViewController.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 16.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var pinTitleLabel: UILabel!
    @IBOutlet weak var pinSubmitButton: UIButton!
    @IBOutlet weak var pinTextField: UITextField!
    
    @IBAction func settingsTapped(_ sender: Any) {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pinTitleLabel.text = "Enter pin"
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
        self.view.addGestureRecognizer(recognizer)
        
        self.setUpSubmitButton()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.view.backgroundColor = .white
    }
    
    func setUpSubmitButton() {
        self.pinSubmitButton.setTitleColor(.white, for: .normal)
        self.pinSubmitButton.layer.backgroundColor = UIColor(red: 232/255, green: 70/255, blue: 43/255, alpha: 1).cgColor
        self.pinSubmitButton.layer.cornerRadius = 8
        self.pinSubmitButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.pinSubmitButton.layer.shadowOpacity = 0.3
        self.pinSubmitButton.layer.shadowRadius = 10.0
        self.pinSubmitButton.layer.masksToBounds = false
    }

    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
    }
    
    @objc func resignKeyboard() {
        self.pinTextField.resignFirstResponder()
    }

    @IBAction func pinSubmitButtonTapped(_ sender: Any) {
        if let pin = self.pinTextField.text {
            let checkin = Checkin()
            checkin.check(pin, delegate: self)
        }
    }
    
    
    @IBAction func websiteButtonTapped(_ sender: Any) {
        let userDefaults = CheckinUserDefaults()
        if let url = URL(string: userDefaults.urlAdress) {
            UIApplication.shared.open(url) {_ in }
        }
    }
}

extension MainViewController: CheckinPinResponseDelegate {
    
    func validPin(_ message: String) {
        let storyboard = UIStoryboard(name: "Barcode", bundle: nil)
        let barcodeView = storyboard.instantiateViewController(withIdentifier: "BarcodeViewController")
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(barcodeView, animated: true)
        }
    }

    func invalidPin(_ error: String, statusCode: Int) {
        DispatchQueue.main.async {
            if statusCode == 401 {
                self.pinTitleLabel.text = "Invalid PIN"
            } else {
                self.pinTitleLabel.text = "Error: status code \(statusCode)"
            }
            self.pinTitleLabel.textColor = #colorLiteral(red: 0.9098039216, green: 0.2745098039, blue: 0.168627451, alpha: 1)
        }
    }
}

