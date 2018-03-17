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
    private var periodicUpdate: Bool
    private let userDefaults: CheckinUserDefaults

    public init() {
        let userDefaults = CheckinUserDefaults()
        self.userDefaults = userDefaults
        let url = URL(string: userDefaults.urlAdress)
        self.apiUrl = url!
        self.periodicUpdate = userDefaults.autoRefresh
    }
    
    public func check(_ pin: String, delegate: CheckinPinResponseDelegate) {
        
        let param = "pin=\(pin)"
        
        let url = apiUrl.appendingPathComponent("checkpin")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = param.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data else { return }
            
            guard let status = response as? HTTPURLResponse, let message = String(data: data, encoding: String.Encoding.utf8) else { return }
            
            if status.statusCode != 200 {
                delegate.invalidPin(message, statusCode: status.statusCode)
            } else {
                self.userDefaults.eventPin = pin
                
                delegate.validPin(message)
            }
        }
        task.resume()
    }
    
    public func check(_ legi: String, mode: CheckinMode, delegate: CheckLegiRequestDelegate) {
        
        guard let pin = self.userDefaults.eventPin else { return }
        
        let param = "pin=\(pin)&checkmode=\(mode.description)&info=\(legi)"
        
        let url = apiUrl.appendingPathComponent("mutate")
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
        guard let pin = self.userDefaults.eventPin else { return }
        
        print(pin)
        
        let url = apiUrl.appendingPathComponent("checkin_update_data")
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
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(EventDetail.self, from: data)
                    delegate.eventDetailsCheckSuccess(json)
                } catch let error {
                    print("Error parsing json: ", message)
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    public func startPeriodicUpdate(_ delegate: CheckEventDetailsRequestDelegate) {
        guard self.periodicUpdate else { return }
        let queue = DispatchQueue.global(qos: .background)
        self.checkEventDetails(delegate)
        queue.asyncAfter(deadline: DispatchTime.now() + self.userDefaults.refreshFrequency) {
            self.startPeriodicUpdate(delegate)
        }
    }
    
    public func stopPeriodicUpdate() {
        self.periodicUpdate = false
    }
    
}
