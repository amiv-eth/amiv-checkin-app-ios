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
        
        let parameters = ["pin": pin]
        
        let url = apiUrl.appendingPathComponent("checkpin")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        print("request: ", request)
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data else { return }
            
            guard let status = response as? HTTPURLResponse else { return }
            
            let json: [String: Any]
            do {
                json = (try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any])!
            } catch let error {
                print(error.localizedDescription)
                return
            }
            print(json)
            if status.statusCode != 200 {
                delegate.invalidPin(String(describing: json), statusCode: status.statusCode)
            } else {
                delegate.validPin()
            }
        }
        task.resume()
        
        
    }
    
}
