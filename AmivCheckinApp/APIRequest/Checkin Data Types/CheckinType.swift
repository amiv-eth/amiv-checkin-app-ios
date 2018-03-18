//
//  CheckinType.swift
//  AmivCheckinApp
//
//  Created by Nicolas Vetsch on 18.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//


import Foundation

/**
 
 Struct describing the type of event as part of the event infos in server-returned event detail data.
 
 (EventType \elementOf EventInfos \subsetOf EventDetail)
 
 */
public enum CheckinType: Codable {
    
    case in_out
    case counter
    
    private enum CodingKeys: String, CodingKey {
        case in_out = "Check-in/Check-out event"
        case counter = "Check-in count event"
    }
    
    public init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        switch label {
        case CodingKeys.in_out.rawValue:
            self = .in_out
        case CodingKeys.counter.rawValue:
            self = .counter
        default:
            self = .in_out
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        debugPrint("encoding...")
    }
}

extension CheckinType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .in_out:
            return "Check-in/Check-out event"
        case .counter:
            return "Check-in count event"
        }
    }
}
