//
//  BarcodeScanViewControllerExtension.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

// MARK: - AVCaptureMetadataOutputObjectsDelegate protocol extension
extension BarcodeScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            let legi = stringValue.replacingOccurrences(of: " ", with: "@")
            self.captureSession.stopRunning()
            let checkin = Checkin()
            checkin.check(legi, mode: CheckinMode.fromHash(self.checkSegmentedControl.selectedSegmentIndex), delegate: self)
        }
    }
}
