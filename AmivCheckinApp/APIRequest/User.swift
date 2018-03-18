//
//  User.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

/**
 
 Struct describing the user data the server gives us.
 
 */
public struct User: Codable {
    
    let checked_in: Bool
    let email: String
    let firstname: String
    let lastname: String
    let legi: String
    let membership: UserMembership
    let nethz: String
    let signup_id: Int
    let user_id: String
    
}
