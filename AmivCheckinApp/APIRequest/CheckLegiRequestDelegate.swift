//
//  CheckLegiRequestDelegate.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

/**
 
 Protocol for handling Legi check responses
 
 */
public protocol CheckLegiRequestDelegate {
    
    /**
     
     Function defining the response to a successful Legi check.
     
     - parameters:
        - response: Server response for the valid Legi (json file)
     
    */
    func legiCheckSuccess(_ response: CheckOutResponse)
    
    /**
     
     Function defining the response to a failed Legi check
     
     - parameters:
        - error: the error String of the failed check
        - statusCode: status code of the failed check
     */
    func legiCheckFailed(_ error: String, statusCode: Int)
    func checkError(_ message: String)
    
}
