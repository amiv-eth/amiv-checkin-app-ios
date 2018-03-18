//
//  CheckinMode.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

/**
 
 An enum as a help to decide whether to check users in or check them out.
 
 */
public enum CheckinMode {
    
    case checkIn
    case checkOut
    
}

extension CheckinMode {
    
    static func fromHash(_ value: Int) -> CheckinMode {
        switch value {
        case 0:
            return .checkIn
        case 1:
            return .checkOut
        default:
            return .checkIn
        }
    }
    
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
