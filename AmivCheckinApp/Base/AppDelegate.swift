//
//  AppDelegate.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 16.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // testing
        // pin: 84538431
        // legi: S17948324
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        let defaults = CheckinUserDefaults()
        defaults.eventPin = nil
    }


}

