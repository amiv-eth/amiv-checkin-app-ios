//
//  CheckEventDetailsRequestDelegate.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

/**
 
 Protocol for handling event detail check responses
 
 */
public protocol CheckEventDetailsRequestDelegate {
    
    /**
     
     Function defining the response to a successful event-details-lookup
     
     - parameters:
        - eventDetail: Server response for the event-details-check (json file)
     
     */
    func eventDetailsCheckSuccess(_ eventDetail: EventDetail)
    
    /**
     
     Function defining the response to a failed event-details-lookup
     
     - parameters:
        - error: error String for the failed check
        - statusCode: status code of the failed check
     
     */
    func eventDetailsCheckFailed(_ error: String, statusCode: Int)
    
}
