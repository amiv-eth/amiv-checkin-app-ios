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
    
    /**
     
     Function for checking an event PIN.
     
     - parameters:
        - pin: the PIN to be checked
        - delegate: a CheckinPinResponseDelegate
     
     */
    public func check(_ pin: String, delegate: CheckinPinResponseDelegate) {
        
        // contructing URL request
        let param = "pin=\(pin)"
        let url = apiUrl.appendingPathComponent("checkpin")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = param.data(using: .utf8)
        
        // configuration such that URL session times out after a reasonable amount of time
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        config.timeoutIntervalForResource = 5
        
        // URL Session task
        let task = URLSession(configuration: config).dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data else {
                delegate.checkPinError((error?.localizedDescription)!)
                return }
            
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
    
    /**
     
     Function for checking a scanned Legi.
     
     - parameters:
        - pin: the PIN to be checked
        - mode: whether to check in or out, represented as a CheckinMode
        - delegate: a CheckLegiRequestDelegate
     
     */
    public func check(_ legi: String, mode: CheckinMode, delegate: CheckLegiRequestDelegate) {
        
        // contructing URL request
        guard let pin = self.userDefaults.eventPin else { return }
        
        let param = "pin=\(pin)&checkmode=\(mode.description)&info=\(legi)"
        let url = apiUrl.appendingPathComponent("mutate")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = param.data(using: .utf8)
        
        // URL Session task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data else {
                delegate.checkLegiError((error?.localizedDescription)!)
                return
            }
            
            guard let status = response as? HTTPURLResponse, let message = String(data: data, encoding: String.Encoding.utf8) else { return }
            
            if status.statusCode != 200 {
                delegate.legiCheckFailed(message, statusCode: status.statusCode)
            } else {
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(CheckOutResponse.self, from: data)
                    delegate.legiCheckSuccess(json)
                } catch {
                    debugPrint("Error parsing json: ", message)
                }
                
            }
        }
        task.resume()
    }
    
    /**
     
     Function for checking event details.
     
     - parameters:
        - delegate: a CheckEventDetailsRequestDelegate
     
     */
    public func checkEventDetails(_ delegate: CheckEventDetailsRequestDelegate) {
        
        // contructing URL request
        guard let pin = self.userDefaults.eventPin else { return }
        
        let url = apiUrl.appendingPathComponent("checkin_update_data")
        var request = URLRequest(url: url)
        request.setValue(pin, forHTTPHeaderField: "pin")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data else { return }
            
            guard let status = response as? HTTPURLResponse, let message = String(data: data, encoding: String.Encoding.utf8) else { return }
            print(message)
            if status.statusCode != 200 {
                delegate.eventDetailsCheckFailed(message, statusCode: status.statusCode)
            } else {
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(EventDetail.self, from: data)
                    delegate.eventDetailsCheckSuccess(json)
                } catch let error {
                    debugPrint("Error parsing json: ", message)
                    debugPrint(error)
                }
            }
        }
        task.resume()
    }
    
    private func callUpdate(_ delegate: CheckEventDetailsRequestDelegate) {
        guard self.periodicUpdate else { return }
        
        let queue = DispatchQueue.global(qos: .background)
        self.checkEventDetails(delegate)
        queue.asyncAfter(deadline: DispatchTime.now() + Double(self.userDefaults.refreshFrequency)) {
            self.callUpdate(delegate)
        }
    }
    
    public func startPeriodicUpdate(_ delegate: CheckEventDetailsRequestDelegate) {
        guard self.userDefaults.autoRefresh else { return }
        self.periodicUpdate = true
        
        self.callUpdate(delegate)
    }
    
    public func stopPeriodicUpdate() {
        self.periodicUpdate = false
    }
    
}
