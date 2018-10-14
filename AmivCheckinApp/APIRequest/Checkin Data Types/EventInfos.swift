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
    let max_freebies: Int?
    let signup_count: Int
    let spots: Int?
    let time_start: String?
    let title: String
}

extension EventInfos {
    
    /**
     Get Event Details to display on statistics table view
     
     - Returns: Key (title) and associated value
     
     */
    public func getDetail() -> [(String, value: String)] {
        
        var details: [(String, String)] = []
        
        details.append(("Title", self.title))
        details.append(("Description", self.description != nil ? self.description! : "No Description"))
        details.append(("Event Type", self.event_type.description))
        details.append(("Number of Signups", String(self.signup_count)))
        
        if let maxFreebies = self.max_freebies {
            details.append(("Maximum Freebies", String(describing: maxFreebies)))
        }
        
        if let time = self.time_start {
            details.append(("Start Time", time))
        }
        
        if let spots = self.spots {
            details.append(("Spots", String(describing: spots)))
        }
        
        return details
    }
}
