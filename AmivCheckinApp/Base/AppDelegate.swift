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
        
/*
    Coding-Weekend March 2018 Tests:
         
         PIN: 84538431
         Legi: S17948324
 */
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        let defaults = CheckinUserDefaults()
        defaults.eventPin = nil
    }


}

