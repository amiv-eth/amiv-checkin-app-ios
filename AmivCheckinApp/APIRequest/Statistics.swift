//
//  Statistics.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

/**
 
 Struct describing the statistics returned by the server. These come in key-value pairs, such as:
 
 Regular Members : 12,
 Extraordinary Members : 3,
 Total Attendance : 17,
 ...
 
 The two statistics first sent are displayed in the barcode scanning view.
 
 */
public struct Statistics: Codable {
    
    let key: String
    let value: Int
    
}
