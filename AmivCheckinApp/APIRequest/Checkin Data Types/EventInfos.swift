//
//  EventInfos.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

/**
 
 Struct describing infos in server-returned event detail data.
 
 */
public struct EventInfos: Decodable {
    
    // MARK: - Variables
    
    let _id: String
    let description: String?
    let event_type: EventType
    let signup_count: Int
    let spots: Int?
    let time_started: String?
    let title: String
}

extension EventInfos {
    
    /**
     Get Event Details to display on statistics table view
     
     - Parameter at: IndexPath of element to display
     
     - Returns: Key (title) and associated value
     
     */
    public func getDetail(_ at: Int) -> (String, value: String) {
        switch at {
        case 0:
            return ("Title", self.title)
        case 1:
            return ("Identifier", self._id)
        case 2:
            return ("Description", self.description != nil ? self.description! : "NaN")
        case 3:
            return ("Event Type", self.event_type.description)
        case 4:
            return ("Number of Signups", String(self.signup_count))
        case 5:
            return ("Spots", self.spots != nil ? String(describing: self.spots!) : "NaN")
        case 6:
            return ("Start Time", self.time_started != nil ? self.time_started! : "NaN")
        default:
            return ("NaN", "NaN")
        }
    }
}
