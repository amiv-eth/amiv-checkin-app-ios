//
//  StatisticsTableViewController.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import UIKit

class StatisticsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var eventDetail: EventDetail?
    
    @IBOutlet weak var statisticsTableView: UITableView!
    
    enum State {
        case statistics
        case people
        case eventInfo
    }
    
    var state: State {
        didSet {
            statisticsTableView.reloadData()
        }
    }
    @IBOutlet weak var stateSegmentedControl: UISegmentedControl!
    
    @IBAction func stateSegmentedControl(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = eventDetail?.signups.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell") as! UserTableViewCell
        
        cell.nameLabel.text = self.eventDetail?.signups[indexPath.row].firstname
        cell.legiLabel.text = self.eventDetail?.signups[indexPath.row].legi
        if (self.eventDetail?.signups[indexPath.row].checked_in)! {
            cell.statusLabel.text = "In"
        } else {
            cell.statusLabel.text = "Out"
        }
        cell.membershipStatusLabel.text = self.eventDetail?.signups[indexPath.row].membership
    
        return cell
    }

}
