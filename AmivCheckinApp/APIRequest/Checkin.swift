//
//  Checkin.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

public class Checkin {
    
    private let apiUrl: URL

    public init() {
        let userDefaults = CheckinUserDefaults()
        let url = URL(string: userDefaults.urlAdress)
        self.apiUrl = url!
    }
    
    func check(_ pin: String, delegate: CheckinPinResponseDelegate) {
        
        let param = "pin=\(pin)"
        
        //let url = apiUrl.appendingPathComponent("checkpin")
        let url = URL(string: "http://10.0.1.6:5000/checkpin")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = param.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data else { return }
            
            guard let status = response as? HTTPURLResponse, let message = String(data: data, encoding: String.Encoding.utf8) else { return }
            
            if status.statusCode != 200 {
                delegate.invalidPin(message, statusCode: status.statusCode)
            } else {
                delegate.validPin(message)
            }
        }
        task.resume()
    }
    
}
