//
//  CheckLegiRequestDelegate.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

public protocol CheckLegiRequestDelegate {
    
    func legiCheckSuccess(_ response: CheckOutResponse)
    func legiCheckFailed(_ error: String, statusCode: Int)
    func checkError(_ message: String)
    
}
