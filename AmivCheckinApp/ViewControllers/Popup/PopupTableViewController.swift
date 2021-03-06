//
//  PopupTableViewController.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 18.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import UIKit

class PopupTableViewController: UIViewController {

    // MARK: - IB Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    
    var user: User?
    var details: [(String, String)] = []
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor  = .clear
        self.view.layer.backgroundColor = UIColor.clear.cgColor
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewController))
        self.view.addGestureRecognizer(recognizer)
        
        self.tableView.layer.cornerRadius = 15
        self.tableView.backgroundColor = .clear
        self.tableView.layer.backgroundColor = UIColor.clear.cgColor
        
        if let user = self.user {
            self.details = user.getDetail()
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.addBlur()
    }
    
    func addBlur() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, belowSubview: self.tableView)
    }
    
    // MARK: - UI Functions
    
    @objc func dismissViewController() {
        self.dismiss(animated: false, completion: nil)
    }

}

// MARK: - UITableView Protocols extension
extension PopupTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "popupCell") as? PopupTableViewCell else {
            return UITableViewCell()
        }
        
        let info = self.details[indexPath.row]
        cell.config(info.0, value: info.1)
        cell.selectionStyle = .none
        
        return cell
    }
}
