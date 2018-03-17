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
    
    @IBOutlet weak var checkSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var manualInputTextField: UITextField!
    @IBOutlet weak var currentCountLabel: UILabel!
    @IBOutlet weak var regularCountLabel: UILabel!
    
    // Variables
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var eventDetail: EventDetail? {
        didSet {
            self.currentCountLabel.text = String(describing: eventDetail?.statistics.first?.value)
            self.regularCountLabel.text = String(describing: eventDetail?.statistics[1].value)
        }
    }
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manualInputTextField.placeholder = "Legi #, email, or nethz"
        self.submitButtonSetup()
        
        self.currentCountLabel.textColor = UIColor(red: 232/255, green: 70/255, blue: 43/255, alpha: 1)
        self.regularCountLabel.textColor = UIColor(red: 232/255, green: 70/255, blue: 43/255, alpha: 1)
        self.currentCountLabel.text = String(describing: 0)
        self.regularCountLabel.text = String(describing: 0)
        
        self.setupBarcodeScanning()
        captureSession.startRunning()
        
        // hide the feedback overlay
        overlay.isHidden = true
        label.isHidden = true
        image.isHidden = true
        
        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignKeyboard))
        self.view.addGestureRecognizer(keyboardRecognizer)
        
        // initialize tap gesture recognizer on overlay
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.overlayTapped(_:)))
        self.overlay.addGestureRecognizer(recognizer)
        recognizer.numberOfTapsRequired = 1
        
        let checkin = Checkin()
        checkin.startPeriodicUpdate(self)
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
        self.submitButton.layer.backgroundColor = UIColor(red: 232/255, green: 70/255, blue: 43/255, alpha: 1).cgColor
        self.submitButton.layer.cornerRadius = 5
    }
    
    // MARK: - View functions
    
    @IBAction func SubmitButtonTapped(_ sender: Any) {
        self.manualInputTextField.resignFirstResponder()
        
        if let legi = self.manualInputTextField.text {
            let checkin = Checkin()
            checkin.check(legi, mode: CheckinMode.fromHash(self.checkSegmentedControl.selectedSegmentIndex), delegate: self)
        }
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
        self.configureOverlay(message, textColor: #colorLiteral(red: 0.003053205786, green: 0.692053318, blue: 0.3124624491, alpha: 1), overlayTint: #colorLiteral(red: 0.003053205786, green: 0.692053318, blue: 0.3124624491, alpha: 0.2), image: #imageLiteral(resourceName: "green_check"))
    }
    
    func invalidLegi(message: String) {
        self.configureOverlay(message, textColor: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), overlayTint: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.2), image: #imageLiteral(resourceName: "red_cross"))
    }
    
    func configureOverlay(_ message: String, textColor: UIColor, overlayTint: UIColor, image: UIImage) {
        // display an overlay and give quick vibration feedback
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        // configure for success
        label.text = message
        label.textColor = textColor
        overlay.tintColor = overlayTint
        self.image.image = image
        
        // show overlay
        overlay.isHidden = false
        label.isHidden = false
        self.image.isHidden = false
    }
    
    @objc func overlayTapped(_ sender: UITapGestureRecognizer) {
        // hide overlay
        overlay.isHidden = true
        label.isHidden = true
        image.isHidden = true
        
        // restart scanning
        captureSession.startRunning()
    }
    
    @objc func resignKeyboard() {
        self.manualInputTextField.resignFirstResponder()
    }
    
    // MARK: - Statistics View
    
    @IBAction func statisticsButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Barcode", bundle: nil)
        let statisticsViewController = storyboard.instantiateViewController(withIdentifier: "StatisticsViewController") as! StatisticsTableViewController
        statisticsViewController.eventDetail = self.eventDetail
        self.navigationController?.pushViewController(statisticsViewController, animated: true)
    }
}

extension BarcodeScanViewController: CheckLegiRequestDelegate {
    
    func legiCheckSuccess(_ response: CheckOutResponse) {
        DispatchQueue.main.async {
            switch response.signup.membership {
            case .extraordinary, .honorary:
                self.configureOverlay(response.message, textColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), overlayTint: #colorLiteral(red: 0.9609039426, green: 0.6258733273, blue: 0.3316327631, alpha: 1), image: #imageLiteral(resourceName: "green_check"))
                self.image.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            case .regular:
                self.configureOverlay(response.message, textColor: #colorLiteral(red: 0.003053205786, green: 0.692053318, blue: 0.3124624491, alpha: 1), overlayTint: #colorLiteral(red: 0.003053205786, green: 0.692053318, blue: 0.3124624491, alpha: 0.2), image: #imageLiteral(resourceName: "green_check"))
            case .none:
                self.configureOverlay(response.message, textColor: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), overlayTint: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.2), image: #imageLiteral(resourceName: "red_cross"))
            }
        }
    }
    
    func legiCheckFailed(_ error: String, statusCode: Int) {
        DispatchQueue.main.async {
            self.configureOverlay(error, textColor: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), overlayTint: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.2), image: #imageLiteral(resourceName: "red_cross"))
        }
    }
}

extension BarcodeScanViewController: CheckEventDetailsRequestDelegate {
    
    func eventDetailsCheckSuccess(_ eventDetail: EventDetail) {
        self.eventDetail = eventDetail
    }
    
    func eventDetailsCheckFailed(_ error: String, statusCode: Int) {
        print("Event Detial check failed")
    }
}

