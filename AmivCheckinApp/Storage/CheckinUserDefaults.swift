//
//  CheckinUserDefaults.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation
import UIKit

/**
 
 UserDefaults wrapper to store settings data for Checkin app
 
 */
public class CheckinUserDefaults {
    
    private let userDefaults = UserDefaults()
    
    // MARK: - URLAdress
    
    private let urlAdressKey = "urlAdress"
    
    // Adress of api server
    public var urlAdress: String {
        get {
            if self.userDefaults.string(forKey: self.urlAdressKey) == nil {
                self.userDefaults.set("https://checkin.amiv.ethz.ch", forKey: self.urlAdressKey)
            }
            return self.userDefaults.string(forKey: self.urlAdressKey)!
        }
        set(value) {
            self.userDefaults.set(value, forKey: self.urlAdressKey)
        }
    }
    
    // MARK: - EventPin
    
    private let eventPinKey = "eventKey"
    
    // Valid Pin for current event
    public var eventPin: String? {  
        get {
            return self.userDefaults.string(forKey: self.eventPinKey)
        }
        set(value) {
            self.userDefaults.set(value, forKey: self.eventPinKey)
        }
    }
    
    // MARK: - AutoRefresh
    
    private let autoRefreshKey = "autoRefresh"
    
    // Turns on auto refresh
    public var autoRefresh: Bool {
        get {
            if self.userDefaults.string(forKey: self.autoRefreshKey) == nil {
                self.userDefaults.set(true, forKey: self.autoRefreshKey)
            }
            return self.userDefaults.bool(forKey: self.autoRefreshKey)
        }
        set(value) {
            self.userDefaults.set(value, forKey: self.autoRefreshKey)
        }
        
    }
    
    // MARK: - RefreshFrequency
    
    private let refreshFrequencyKey = "refreshFrequency"
    
    // Frequency to automatically refresh data from server
    public var refreshFrequency: Int {
        get {
            if self.userDefaults.string(forKey: self.refreshFrequencyKey) == nil {
                self.userDefaults.set(20, forKey: self.refreshFrequencyKey)
            }
            return self.userDefaults.integer(forKey: self.refreshFrequencyKey)
        }
        set(value) {
            self.userDefaults.set(value, forKey: self.refreshFrequencyKey)
        }
    }
}
