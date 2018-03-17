//
//  CheckinMode.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

public enum CheckinMode {
    
    case checkIn
    case checkOut
    
}

extension CheckinMode: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .checkIn:
            return "in"
        case .checkOut:
            return "out"
        }
    }
}
