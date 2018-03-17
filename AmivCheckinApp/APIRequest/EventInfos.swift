//
//  EventInfos.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

public struct EventInfos: Codable {
    
    let _id: String
    let description: String
    let event_type: String
    let signup_count: Int
    let spots: Int?
    let time_started: String?
    let title: String
    
}
