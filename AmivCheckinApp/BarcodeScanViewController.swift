//
//  BarcodeScanViewController.swift
//  AmivCheckinApp
//
//  Created by Domenic Wüthrich on 17.03.18.
//  Copyright © 2018 Domenic Wüthrich. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class BarcodeScanViewController: UIViewController {
    
    // MARK: - IB Variables
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var manualInputTextField: UITextField!
    @IBOutlet weak var currentCountLabel: UILabel!
    @IBOutlet weak var regularCountLabel: UILabel!
    
    // Variables
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manualInputTextField.placeholder = "Legi Nr., Email, ..."
        self.submitButtonSetup()
        
        self.setupBarcodeScanning()
        captureSession.startRunning()
    }
    
    func setupBarcodeScanning() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            debugPrint("no camera")
            return
            
        }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            //failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.code39]
        } else {
            //failed()
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        previewLayer!.frame = self.view.layer.bounds
        previewLayer!.videoGravity = .resizeAspectFill
        self.view.layer.insertSublayer(previewLayer!, below: self.manualInputTextField.layer)
        
        debugPrint("Set up success")
    }
    
    func submitButtonSetup() {
        self.submitButton.setTitleColor(.white, for: .normal)
        self.submitButton.layer.backgroundColor = UIColor.red.cgColor
        self.submitButton.layer.cornerRadius = 5
    }
    
    // MARK: - View functions
    
    @IBAction func SubmitButtonTapped(_ sender: Any) {
        debugPrint(self.manualInputTextField.text!)
    }
    
    // MARK: - Barcode Handling
    
    func foundBarcode(_ code: String) {
        print(code)
    }
    
    func setupFailed() {
        debugPrint("Failed to set up barcode scanning")
    }
    
}

