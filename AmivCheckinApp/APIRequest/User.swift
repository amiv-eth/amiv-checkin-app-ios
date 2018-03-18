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
    let legi: String?
    let membership: UserMembership
    let nethz: String?
    let signup_id: Int
    let user_id: String
    
    public func getDetail(_ at: Int) -> (String, value: String) {
        switch at {
        case 0:
            return ("First name", self.firstname)
        case 1:
            return ("Last name", self.lastname)
        case 2:
            return ("Checked in", self.checked_in ? "In" : "Out")
        case 3:
            return ("Email", self.email)
        case 4:
            return ("Legi", self.legi != nil ? self.legi! : "NaN")
        case 5:
            return ("Membership", self.membership.description)
        case 6:
            return ("NETHZ", self.nethz != nil ? self.nethz! : "NaN")
        case 7:
            return ("Sign up ID", String(describing: self.signup_id))
        case 8:
            return ("User ID", self.user_id)
        default:
            return ("NaN", "NaN")
        }
    }
    
}
