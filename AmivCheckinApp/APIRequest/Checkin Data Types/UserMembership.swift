//
//  UserMembership.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

/**
 
 Membership type of a user. Used to properly display people's membership data in the statistics
 view.
 
 There are four types of users:
 - 'regular'
 - 'extraordinary'
 - 'honorary'
 - 'none' (not a member)
 
 */
public enum UserMembership: Codable {
    
    case regular
    case extraordinary
    case honorary
    case none
    
    private enum CodingKeys: String, CodingKey {
        case regular
        case extraordinary
        case honorary
        case none
    }
    
    public init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        switch label {
        case CodingKeys.regular.rawValue:
            self = .regular
        case CodingKeys.extraordinary.rawValue:
            self = .extraordinary
        case CodingKeys.honorary.rawValue:
            self = .honorary
        case CodingKeys.none.rawValue:
            self = .none
        default:
            self = .none
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        print("encoding membership")
    }
    
}

extension UserMembership: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .extraordinary:
            return "Extraordinary"
        case .honorary:
            return "Honorary"
        case .regular:
            return "Regular"
        case .none:
            return "None"
        }
    }
    
}


