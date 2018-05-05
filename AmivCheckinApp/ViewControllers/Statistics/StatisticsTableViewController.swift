//
//  StatisticsTableViewController.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import UIKit

class StatisticsTableViewController: UIViewController {

    // MARK: - Variables
    
    var eventDetail: EventDetail?
    var eventInfos: [(String, String)] = []
    let checkin = Checkin()
    let searchController = UISearchController()
    
    // MARK: - IB Variables
    
    @IBOutlet weak var statisticsTableView: UITableView!
    @IBOutlet weak var stateSegmentedControl: UISegmentedControl!
    
    // MARK: - Identifier Enums
    
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
    
    var state: State = .eventInfo {
        didSet {
            statisticsTableView.reloadData()
        }
    }
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stateSegmentedControl.layer.cornerRadius = 0
        self.stateSegmentedControl.layer.borderColor = UIColor(red: 232/255, green: 70/255, blue: 43/255, alpha: 1).cgColor
        self.stateSegmentedControl.layer.borderWidth = 1
        self.stateSegmentedControl.layer.masksToBounds = true
        
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(self.refreshUI), for: .valueChanged)
        self.statisticsTableView.refreshControl = refreshController
        
        if let detail = self.eventDetail {
            self.eventInfos = detail.eventinfos.getDetail()
        }
        
        self.setupSegmentedControl()
        
        //self.setupSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkin.startPeriodicUpdate(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.checkin.stopPeriodicUpdate()
    }
    
    func setupSegmentedControl() {
        self.stateSegmentedControl.setTitle("Event Info", forSegmentAt: 0)
        self.stateSegmentedControl.setTitle("People", forSegmentAt: 1)
        self.stateSegmentedControl.setTitle("Stats", forSegmentAt: 2)
        self.stateSegmentedControl.selectedSegmentIndex = 0
    }
    
    // TODO: Implement search controller
    func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.statisticsTableView.tableHeaderView = searchController.searchBar
    }
    
    @objc func refreshUI() {
        self.statisticsTableView.refreshControl?.endRefreshing()
        self.checkin.checkEventDetails(self)
    }
    
    // MARK: - UI Functions
    
    @IBAction func stateSegmentedControl(_ sender: Any) {
        switch self.stateSegmentedControl.selectedSegmentIndex {
        case 0:
            self.state = .eventInfo
            self.statisticsTableView.allowsSelection = false
        case 1:
            self.state = .people
            self.statisticsTableView.allowsSelection = true
        default:
            self.state = .statistics
            self.statisticsTableView.allowsSelection = false
        }
    }
}

// MARK: - UITableView Protocol extension
extension StatisticsTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let detail = eventDetail {
            switch self.state {
            case .eventInfo:
                return self.eventInfos.count
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
            let infos = self.eventInfos[indexPath.row]
            cell.config(infos.0, value: infos.1)
            cell.selectionStyle = .none
            return cell
        case .people:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.peopleCell.rawValue) as! UserTableViewCell
            cell.config(data.signups[indexPath.row])
            cell.selectionStyle = .none
            return cell
        case .statistics:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.statisticsCell.rawValue) as! StatisticsTableViewCell
            cell.config(data.statistics[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.state == .people {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Popup", bundle: nil)
                let popup = storyboard.instantiateViewController(withIdentifier: "popupViewController") as! PopupTableViewController
                popup.modalPresentationStyle = .overFullScreen
                popup.user = self.eventDetail?.signups[indexPath.row]
                self.present(popup, animated: false, completion: nil)
            }
        }
    }
}

// MARK: - CheckEventDetailsRequestDelegate protocol extension
extension StatisticsTableViewController: CheckEventDetailsRequestDelegate {
    
    func eventDetailsCheckSuccess(_ eventDetail: EventDetail) {
        DispatchQueue.main.async {
            self.eventDetail = eventDetail
            self.statisticsTableView.reloadData()
        }
    }
    
    func eventDetailsCheckFailed(_ error: String, statusCode: Int) {
        debugPrint("Periodic update failure")
    }
    
    func checkEventDetailsError(_ message: String) {
        debugPrint(message)
    }
}

// MARK: - UISearchResultsUpdating protocol extension
extension StatisticsTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.statisticsTableView.reloadData()
    }
    
}
