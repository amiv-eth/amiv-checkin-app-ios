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
        
        self.manualInputTextField.placeholder = "Legi #, email, or nethz"
        self.submitButtonSetup()
        
        self.setupBarcodeScanning()
        captureSession.startRunning()
        
        // hide the feedback overlay
        overlay.isHidden = true
        label.isHidden = true
        image.isHidden = true
        
        // initialize tap gesture recognizer on overlay
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.overlayTapped(_:)))
        self.overlay.addGestureRecognizer(recognizer)
        recognizer.numberOfTapsRequired = 1
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
            setupFailed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.code39]
        } else {
            setupFailed()
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        previewLayer!.frame = self.view.layer.bounds
        previewLayer!.videoGravity = .resizeAspectFill
        self.view.layer.insertSublayer(previewLayer!, below: self.overlay.layer)
        
        debugPrint("Set up success")
    }
    
    func submitButtonSetup() {
        self.submitButton.setTitleColor(.white, for: .normal)
        self.submitButton.layer.backgroundColor = UIColor.red.cgColor
        self.submitButton.layer.cornerRadius = 5
    }
    
    // MARK: - View functions
    
    @IBAction func SubmitButtonTapped(_ sender: Any) {
        self.manualInputTextField.resignFirstResponder()
        debugPrint(self.manualInputTextField.text!)
    }
    
    // MARK: - Barcode Handling
    
    func foundBarcode(_ code: String) {
        debugPrint(code)
        
        // determine whether valid barcode or not and go to invalidLegi/validLegi accordingly
        
    }
    
    func setupFailed() {
        debugPrint("Failed to set up barcode scanning")
    }
    
    // Overlays for success and failure
    //
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    func validLegi(message: String) {
        captureSession.stopRunning()    // stop capture session until tap
        
        // display an overlay and give quick vibration feedback
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        // configure for success
        label.text = message
        label.textColor = #colorLiteral(red: 0.003053205786, green: 0.692053318, blue: 0.3124624491, alpha: 1)
        overlay.tintColor = #colorLiteral(red: 0.003053205786, green: 0.692053318, blue: 0.3124624491, alpha: 0.2)
        image.image = #imageLiteral(resourceName: "green_check")
        
        // show overlay
        overlay.isHidden = false
        label.isHidden = false
        image.isHidden = false
    }
    
    func invalidLegi(message: String) {
        captureSession.stopRunning()    // stop capture session until tap
        
        // display an overlay and give quick vibration feedback
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        // configure for success
        label.text = message
        label.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        overlay.tintColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.2)
        image.image = #imageLiteral(resourceName: "red_cross")
        
        // show overlay
        overlay.isHidden = false
        label.isHidden = false
        image.isHidden = false
    }
    
    @objc func overlayTapped(_ sender: UITapGestureRecognizer) {
        // hide overlay
        overlay.isHidden = true
        label.isHidden = true
        image.isHidden = true
        
        // restart scanning
        captureSession.startRunning()
    }
    
    // MARK: - Statistics View
    
    @IBAction func statisticsButton(_ sender: Any) {
        performSegue(withIdentifier: "statisticsSegue", sender: sender)
    }
    
    
}

