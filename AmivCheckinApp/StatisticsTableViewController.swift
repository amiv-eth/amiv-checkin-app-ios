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
    let checkin = Checkin()
    
    @IBOutlet weak var statisticsTableView: UITableView!
    
    enum CellIdentifier: String {
        case peopleCell
        case statisticsCell
        case eventCell
    }
    
    enum State {
        case statistics
        case people
        case eventInfo
    }
    
    var state: State = .statistics {
        didSet {
            statisticsTableView.reloadData()
        }
    }
    @IBOutlet weak var stateSegmentedControl: UISegmentedControl!
    
    @IBAction func stateSegmentedControl(_ sender: Any) {
        switch self.stateSegmentedControl.selectedSegmentIndex {
        case 0:
            self.state = .statistics
        case 1:
            self.state = .people
        default:
            self.state = .eventInfo
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stateSegmentedControl.layer.cornerRadius = 0
        self.stateSegmentedControl.layer.borderColor = UIColor(red: 232/255, green: 70/255, blue: 43/255, alpha: 1).cgColor
        self.stateSegmentedControl.layer.borderWidth = 1
        self.stateSegmentedControl.layer.masksToBounds = true
        
        self.statisticsTableView.allowsSelection = false
        
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(self.refreshUI), for: .valueChanged)
        self.statisticsTableView.refreshControl = refreshController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkin.startPeriodicUpdate(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.checkin.stopPeriodicUpdate()
    }
    
    @objc func refreshUI() {
        self.statisticsTableView.refreshControl?.endRefreshing()
        self.checkin.checkEventDetails(self)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let detail = eventDetail {
            switch self.state {
            case .eventInfo:
                return 7
            case .people:
                return detail.signups.count
            case .statistics:
                return detail.statistics.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = self.eventDetail else { return UITableViewCell() }
        switch self.state {
        case .eventInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.eventCell.rawValue) as! EventInfoTableViewCell
            let infos = data.eventinfos.getDetail(indexPath.row)
            cell.config(infos.0, value: infos.1)
            return cell
        case .people:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.peopleCell.rawValue) as! UserTableViewCell
            cell.config(data.signups[indexPath.row])
            return cell
        case .statistics:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.statisticsCell.rawValue) as! StatisticsTableViewCell
            cell.config(data.statistics[indexPath.row])
            return cell
        }
    }

}

extension StatisticsTableViewController: CheckEventDetailsRequestDelegate {
    
    func eventDetailsCheckSuccess(_ eventDetail: EventDetail) {
        DispatchQueue.main.async {
            self.eventDetail = eventDetail
            self.statisticsTableView.reloadData()
        }
    }
    
    func eventDetailsCheckFailed(_ error: String, statusCode: Int) {
        print("Periodic update failure")
    }
    
}
