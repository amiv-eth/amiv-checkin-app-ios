//
//  CheckinPinResponseDelegate.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

/**
 
 Protocol for handling PIN check responses
 
 */
public protocol CheckinPinResponseDelegate {
    
    /**
     
     Function defining the response to a given valid PIN.
     
     - parameters:
        - message: Server side response as String
     */
    func validPin(_ message: String)
    
    /**
     
     Function defining the response to a given invalid PIN
     
     - parameters:
        - message: Server side response as String
        - statusCode: Returned status code of the HTTP request
     */
    func invalidPin(_ error: String, statusCode: Int)
    
    /**
     
     Function to handle the received error message upon invalid pin request
     
     - parameters:
        - message: Server side response as String
     
     */
    func checkPinError(_ message: String)
}
