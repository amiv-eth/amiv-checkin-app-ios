//
//  CheckinPinResponseDelegate.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

public protocol CheckinPinResponseDelegate {
    
    func validPin()
    func invalidPin(_ error: String, statusCode: Int)
    
}
