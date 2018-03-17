//
//  CheckinUserDefaults.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation
import UIKit

public class CheckinUserDefaults {
    
    private let userDefaults = UserDefaults()
    
    // MARK: - UserDefaults objects
    
    /**
     UserDefault key for firstTime
     
     */
    private let urlAdressKey = "urlAdress"
    
    /**
     First time opening the app
     
     */
    public var urlAdress: Bool {
        get {
            if self.userDefaults?.string(forKey: self.urlAdressKey) == nil {
                self.userDefaults?.set("https://checkin.amiv.ethz.ch", forKey: self.urlAdressKey)
            }
            return (self.userDefaults?.string(forKey: self.urlAdressKey))!
        }
        set(value) {
            self.userDefaults?.set(value, forKey: self.urlAdressKey)
        }
    }
    
}
