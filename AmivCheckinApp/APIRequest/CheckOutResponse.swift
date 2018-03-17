//
//  CheckOutResponse.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

public struct CheckOutResponse: Codable {
    
    let message: String
    let signup: User
    
}
