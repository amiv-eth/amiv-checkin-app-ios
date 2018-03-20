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
 
 Class wherein the user default setting-values of the check-in app are stored
 
 */
public class CheckinUserDefaults {
    
    private let userDefaults = UserDefaults()
    
    // MARK: - UserDefaults objects
    
    // UserDefault settings keys for the first initialization
    private let urlAdressKey = "urlAdress"
    private let autoRefreshKey = "autoRefresh"
    private let refreshFrequencyKey = "refreshFrequency"
    private let eventPinKey = "eventKey"
    
    // Userdefault settings values for the first initialization
    public var urlAdress: String {
        get {       // handling first time opening the app
            if self.userDefaults.string(forKey: self.urlAdressKey) == nil {
                self.userDefaults.set("https://checkin.amiv.ethz.ch", forKey: self.urlAdressKey)
            }
            return self.userDefaults.string(forKey: self.urlAdressKey)!
        }
        set(value) {
            self.userDefaults.set(value, forKey: self.urlAdressKey)
        }
    }
    
    public var eventPin: String? {  
        get {
            return self.userDefaults.string(forKey: self.eventPinKey)
        }
        set(value) {
            self.userDefaults.set(value, forKey: self.eventPinKey)
        }
    }
    
    public var autoRefresh: Bool {
        get {   // handling first time opening the app
            if self.userDefaults.string(forKey: self.autoRefreshKey) == nil {
                self.userDefaults.set(true, forKey: self.autoRefreshKey)
            }
            return self.userDefaults.bool(forKey: self.autoRefreshKey)
        }
        set(value) {
            self.userDefaults.set(value, forKey: self.autoRefreshKey)
        }
        
    }
    
    public var refreshFrequency: Int {
        get {   // handling first time opening the app
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
