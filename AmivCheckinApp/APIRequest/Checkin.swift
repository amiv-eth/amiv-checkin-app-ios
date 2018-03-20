//
//  Checkin.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation

/**
 Backend communication with checkin api server.
 
 - Validate pin code for event
 - Check student in and out of event
 - Get statistics data for current event
 
 */
public class Checkin {
    
    // MARK: - Variables
    
    private let apiUrl: URL
    private var periodicUpdate: Bool
    private let userDefaults: CheckinUserDefaults

    // MARK: - Initializer
    
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
        - pin: The PIN to be checked
        - delegate: Delegate to be called after response from server
     
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
                return
            }
            
            guard let status = response as? HTTPURLResponse, let message = String(data: data, encoding: String.Encoding.utf8) else { return }
            
            if status.statusCode != 200 {
                // Invalid pin
                delegate.invalidPin(message, statusCode: status.statusCode)
            } else {
                // Valid pin
                self.userDefaults.eventPin = pin
                delegate.validPin(message)
            }
        }
        // Start URLSession request
        task.resume()
    }
    
    /**
     
     Function for checking a scanned Legi.
     
     - parameters:
        - legi: Legi number to check In or Out (or NETHZ / email adress of student)
        - mode: Check In or Out of student
        - delegate: Delegate to be called after server response
     
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
                // Check failed
                delegate.legiCheckFailed(message, statusCode: status.statusCode)
            } else {
                // Check was successfull
                do {
                    // Decode response Json as CheckOutResponse
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(CheckOutResponse.self, from: data)
                    delegate.legiCheckSuccess(json)
                } catch {
                    debugPrint("Error parsing json: ", message)
                }
                
            }
        }
        // Start URLSession request
        task.resume()
    }
    
    /**
     
     Function for checking event details.
     
     - parameters:
        - delegate: Delegate to be called after server resposne
     
     */
    public func checkEventDetails(_ delegate: CheckEventDetailsRequestDelegate) {
        
        // contructing URL request
        guard let pin = self.userDefaults.eventPin else { return }
        
        let url = apiUrl.appendingPathComponent("checkin_update_data")
        var request = URLRequest(url: url)
        request.setValue(pin, forHTTPHeaderField: "pin")
        request.httpMethod = "GET"
        
        // URLSession task
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil, let data = data else { return }
            
            guard let status = response as? HTTPURLResponse, let message = String(data: data, encoding: String.Encoding.utf8) else { return }
            print(message)
            if status.statusCode != 200 {
                // Check failed
                delegate.eventDetailsCheckFailed(message, statusCode: status.statusCode)
            } else {
                // Check successfull
                do {
                    // Decode response Json as EventDetail
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(EventDetail.self, from: data)
                    delegate.eventDetailsCheckSuccess(json)
                } catch let error {
                    debugPrint("Error parsing json: ", message)
                    debugPrint(error)
                }
            }
        }
        // Start URLSession request
        task.resume()
    }
    
    /**
     Automatic EventDetails refresh update caller
     
     - Parameter delegate: Delegate to be called after refresh
     
     */
    private func callUpdate(_ delegate: CheckEventDetailsRequestDelegate) {
        guard self.periodicUpdate else { return }
        
        let queue = DispatchQueue.global(qos: .background)
        self.checkEventDetails(delegate)
        queue.asyncAfter(deadline: DispatchTime.now() + Double(self.userDefaults.refreshFrequency)) {
            self.callUpdate(delegate)
        }
    }
    
    /**
     Start automatic EventDetails refresh
     
     - Parameter delegate: Delegate to be called after refresh
     
     */
    public func startPeriodicUpdate(_ delegate: CheckEventDetailsRequestDelegate) {
        guard self.userDefaults.autoRefresh else { return }
        self.periodicUpdate = true
        
        self.callUpdate(delegate)
    }
    
    /**
     Stop automatic EventDetail refresh
     
     */
    public func stopPeriodicUpdate() {
        self.periodicUpdate = false
    }
    
}
