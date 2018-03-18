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
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor  = .clear
        self.view.layer.backgroundColor = UIColor.clear.cgColor
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissViewController))
        self.view.addGestureRecognizer(recognizer)
        
        self.tableView.layer.cornerRadius = 15
    }
    
    override func viewDidLayoutSubviews() {
        self.addBlur()
    }
    
    func addBlur() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurEffectView, belowSubview: self.tableView)
    }
    
    @objc func dismissViewController() {
        self.dismiss(animated: false, completion: nil)
    }

}

extension PopupTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "popupCell") as? PopupTableViewCell, let user = self.user else {
            return UITableViewCell()
        }
        
        let info = user.getDetail(indexPath.row)
        cell.config(info.0, value: info.1)
        cell.selectionStyle = .none
        
        return cell
    }
}
