//
//  EventType.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

/**
 
 Struct describing the type of event as part of the event infos in server-returned event detail data.
 
 (EventType \elementOf EventInfos \subsetOf EventDetail)
 
 */
public enum EventType: Decodable {
    
    case pvk
    case gv
    case counter
    case events
    case unknown
    
    private enum CodingKeys: String, CodingKey {
        case pvk = "AMIV PVK"
        case gv = "AMIV General Assemblies"
        case counter = "XXX COUNTER"
        case events = "AMIV Events"
        case unknown
    }
    
    public init(from decoder: Decoder) throws {
        let label = try decoder.singleValueContainer().decode(String.self)
        switch label {
        case CodingKeys.pvk.rawValue:
            self = .pvk
        case CodingKeys.gv.rawValue:
            self = .gv
        case CodingKeys.counter.rawValue:
            self = .counter
        case CodingKeys.events.rawValue:
            self = .events
        default:
            self = .unknown
        }
    }
}

extension EventType: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .pvk:
            return "AMIV PVK"
        case .gv:
            return "AMIV General Assemblies"
        case .counter:
            return "XXX COUNTER"
        case .events:
            return "AMIV Events"
        case .unknown:
            return "Unknown"
        }
        
    }
    
}
