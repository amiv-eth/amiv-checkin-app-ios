//
//  UserSignups.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

public struct UserSignup: Codable {
    
    let checked_in: Bool
    let email: String
    let firstname: String
    let lastname: String
    let legi: String
    let membership: String
    let nethz: String
    
}
