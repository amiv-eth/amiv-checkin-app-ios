//
//  CheckOutResponse.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

/**
 
 Struct describing the data returned from the server for a Legi check.
 
 */
public struct CheckOutResponse: Decodable {
    
    let message: String
    let signup: User
    
}
