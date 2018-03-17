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
    
    public func check(_ pin: String, delegate: CheckinPinResponseDelegate) {
        
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
                let defaults = CheckinUserDefaults()
                defaults.eventPin = pin
                
                delegate.validPin(message)
                
            }
        }
        task.resume()
    }
    
    public func check(_ legi: String, mode: CheckinMode, delegate: CheckLegiRequestDelegate) {
        
        let defaults = CheckinUserDefaults()
        guard let pin = defaults.eventPin else { return }
        
        let param = "pin=\(pin)&checkmode=\(mode.description)&info=\(legi)"
        
        //let url = apiUrl.appendingPathComponent("mutate")
        let url = URL(string: "http://10.0.1.6:5000/mutate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = param.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data else { return }
            
            guard let status = response as? HTTPURLResponse, let message = String(data: data, encoding: String.Encoding.utf8) else { return }
            
            if status.statusCode != 200 {
                delegate.legiCheckFailed(message, statusCode: status.statusCode)
            } else {
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(CheckOutResponse.self, from: data)
                    delegate.legiCheckSuccess(json)
                } catch {
                    print("Error parsing json: ", message)
                }
                
            }
        }
        task.resume()
    }
    
    public func checkEventDetails(_ delegate: CheckEventDetailsRequestDelegate) {
        let defaults = CheckinUserDefaults()
        guard let pin = defaults.eventPin else { return }
        
        print(pin)
        
        //let url = apiUrl.appendingPathComponent("mutate")
        let url = URL(string: "http://10.0.1.6:5000/checkin_update_data")!
        var request = URLRequest(url: url)
        request.setValue(pin, forHTTPHeaderField: "pin")
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data else { return }
            
            guard let status = response as? HTTPURLResponse, let message = String(data: data, encoding: String.Encoding.utf8) else { return }
            
            if status.statusCode != 200 {
                delegate.eventDetailsCheckFailed(message, statusCode: status.statusCode)
            } else {
                do {
                    print(message)
                    /*
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(CheckOutResponse.self, from: data)
                    delegate.legiCheckSuccess(json)
 */
                } catch {
                    print("Error parsing json: ", message)
                }
                
            }
        }
        task.resume()

    }
    
}
