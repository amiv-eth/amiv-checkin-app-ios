//
//  MainViewController.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 16.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Variables
    
    let userDefaults = CheckinUserDefaults()
    
    // MARK: - IB Variables
    
    @IBOutlet weak var pinTitleLabel: UILabel!
    @IBOutlet weak var pinSubmitButton: UIButton!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var lastSessionButton: UIButton!
    
    // MARK: - Setup
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.userDefaults.eventPin == nil {
            self.lastSessionButton.isHidden = true
            self.lastSessionButton.isEnabled = false
        } else {
            self.lastSessionButton.isHidden = false
            self.lastSessionButton.isEnabled = true
        }
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
    
    @objc func resignKeyboard() {
        self.pinTextField.resignFirstResponder()
    }
    
    // MARK: - View functions
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {}
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }

    @IBAction func pinSubmitButtonTapped(_ sender: Any) {
        if let pin = self.pinTextField.text {
            self.validate(pin)
        }
    }
    
    @IBAction func loadLastSession(_ sender: Any) {
        guard let pin = self.userDefaults.eventPin else {
            return
        }
        
        self.pinTextField.text = pin
        
        self.validate(pin)
    }
    
    @IBAction func websiteButtonTapped(_ sender: Any) {
        if let url = URL(string: self.userDefaults.urlAdress) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Pin Validation
    
    private func validate(_ pin: String) {
        let checkin = Checkin()
        checkin.check(pin, delegate: self)
    }
}

// MARK: - CheckinPinResponseDelegae protocol extension
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
            debugPrint(error)
            self.pinTitleLabel.text = "Invalid PIN"
            self.pinTitleLabel.textColor = #colorLiteral(red: 0.9098039216, green: 0.2745098039, blue: 0.168627451, alpha: 1)
        }
    }
    
    func checkPinError(_ message: String) {
        DispatchQueue.main.async {
            debugPrint(message)
            self.pinTitleLabel.text = "Invalid URL"
            self.pinTitleLabel.textColor = #colorLiteral(red: 0.9098039216, green: 0.2745098039, blue: 0.168627451, alpha: 1)
            
            self.performSegue(withIdentifier: "settingsSegue", sender: self)
        }
    }
}
