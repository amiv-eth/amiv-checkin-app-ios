//
//  EventDetail.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

public struct EventDetail: Codable {
    
    let eventinfos: EventInfos
    let signups: [User]
    let statistics: [Statistics]
    
}
