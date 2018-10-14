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
public struct User: Decodable {
    
    // MARK: - Variables
    
    let checked_in: Bool?
    let email: String
    let firstname: String
    let lastname: String
    let legi: String?
    let membership: UserMembership
    let nethz: String?
    let freebies_taken: Int?
    let signup_id: String
    let user_id: String
    
}

extension User {
    
    /**
     Get User Details to display on statistics table view
     
     - Returns: Key (title) and associated value
     
     */
    public func getDetail() -> [(String, value: String)] {
        
        var detail: [(String, String)] = []
        
        detail.append(("First name", self.firstname))
        detail.append(("Last name", self.lastname))
        
        if let checkedIn = self.checked_in {
            detail.append(("Checked in", checkedIn ? "In" : "Out"))
        }
        
        if let freebiesTaken = self.freebies_taken {
            detail.append(("Freebies Taken", String(describing: freebiesTaken)))
        }
        
        detail.append(("Email", self.email))
        detail.append(("Legi", self.legi != nil ? self.legi! : "No Legi"))
        detail.append(("Membership", self.membership.description))
        detail.append(("NETHZ", self.nethz != nil ? self.nethz! : "No NETHZ Username"))
        
        return detail
    }
}
