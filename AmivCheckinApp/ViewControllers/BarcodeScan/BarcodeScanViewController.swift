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
    @IBOutlet weak var statisticsButton: UIBarButtonItem!
    @IBOutlet weak var checkSegmentedControl: UISegmentedControl!
    @IBOutlet weak var manualInputTextField: UITextField!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var currentCountLabel: UILabel!
    @IBOutlet weak var regularCountLabel: UILabel!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    // Variables
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    let checkin = Checkin()
    
    var eventDetail: EventDetail? {
        didSet {    //  display the two top statistics of the eventinfo
            DispatchQueue.main.async {
                if let first = self.eventDetail?.statistics.first?.value, let second = self.eventDetail?.statistics[1].value {
                    self.currentCountLabel.text = String(describing: first)
                    self.regularCountLabel.text = String(describing: second)
                }
            }
        }
    }
    
    // MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up UI elements
        self.manualInputTextField.placeholder = "Legi #, email, or nethz"
        
        self.setupSubmitButton()
        self.setupInputField()
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.currentCountLabel.textColor = UIColor(red: 232/255, green: 70/255, blue: 43/255, alpha: 1)
        self.currentCountLabel.text = String(describing: 0)
        self.regularCountLabel.textColor = UIColor(red: 232/255, green: 70/255, blue: 43/255, alpha: 1)
        self.regularCountLabel.text = String(describing: 0)
        
        // start scanning for barcodes
        self.setupBarcodeScanning()
        captureSession.startRunning()
        
        // hide the feedback overlay
        overlay.isHidden = true
        label.isHidden = true
        image.isHidden = true
        
        // initialize tap gesture recognizer to resign keyboard
        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.resignKeyboard))
        self.view.addGestureRecognizer(keyboardRecognizer)
        
        // initialize tap gesture recognizer on overlay
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.overlayTapped(_:)))
        self.overlay.addGestureRecognizer(recognizer)
        recognizer.numberOfTapsRequired = 1
        
        // start periodic updates
        self.checkin.startPeriodicUpdate(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkin.startPeriodicUpdate(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.checkin.stopPeriodicUpdate()
    }
    
    override func viewDidLayoutSubviews() {
        self.setupStatsView()
    }
    
    func setupStatsView() {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.statsView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.statsView.insertSubview(blurEffectView, belowSubview: self.manualInputTextField)
        
        let gradient = CAGradientLayer()
        gradient.frame = self.statsView.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.7, 1.0]
        blurEffectView.layer.mask = gradient
    }
    
    func setupSubmitButton() {
        self.submitButton.setTitleColor(.white, for: .normal)
        self.submitButton.layer.backgroundColor = UIColor(red: 232/255, green: 70/255, blue: 43/255, alpha: 1).cgColor
        self.submitButton.layer.cornerRadius = 5
        self.submitButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.submitButton.layer.shadowOpacity = 0.3
        self.submitButton.layer.shadowRadius = 10.0
        self.submitButton.layer.masksToBounds = false
    }
    
    func setupInputField() {
        self.manualInputTextField.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.manualInputTextField.layer.shadowOpacity = 0.3
        self.manualInputTextField.layer.shadowRadius = 10.0
        self.manualInputTextField.layer.masksToBounds = false
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
    
    func setupFailed() {
        debugPrint("Failed to set up barcode scanning")
    }
    
    // MARK: - View functions
    
    @IBAction func SubmitButtonTapped(_ sender: Any) {
        self.manualInputTextField.resignFirstResponder()
        
        if let legi = self.manualInputTextField.text {
            self.checkin.check(legi, mode: CheckinMode.fromHash(self.checkSegmentedControl.selectedSegmentIndex), delegate: self)
        }
    }
    
    @IBAction func statisticsButtonTapped(_ sender: Any) {
        guard let detail = self.eventDetail else { return }
        let storyboard = UIStoryboard(name: "Barcode", bundle: nil)
        let statisticsViewController = storyboard.instantiateViewController(withIdentifier: "StatisticsViewController") as! StatisticsTableViewController
        statisticsViewController.eventDetail = detail
        self.navigationController?.pushViewController(statisticsViewController, animated: true)
    }
    
    // MARK: - Barcode Handling
    
    func configureOverlay(_ message: String, textColor: UIColor, overlayTint: UIColor, image: UIImage, orange: Bool) {
        // display an overlay and give quick vibration feedback
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        // configure overlay for success indication
        label.text = message
        label.textColor = textColor
        overlay.backgroundColor = overlayTint
        self.image.image = image
        self.image.tintColor = textColor
        
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
        
        // restart scanning for barcodes
        captureSession.startRunning()
    }
    
    @objc func resignKeyboard() {
        self.manualInputTextField.resignFirstResponder()
    }
}

// MARK: - CheckLegiRequestDelegate protocol extension
extension BarcodeScanViewController: CheckLegiRequestDelegate {
    
    func legiCheckSuccess(_ response: CheckOutResponse) {
        DispatchQueue.main.async {
            self.checkin.checkEventDetails(self)
            switch response.signup.membership {
            case .extraordinary, .honorary:
                self.configureOverlay(response.message, textColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), overlayTint: #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 0.2), image: #imageLiteral(resourceName: "green_check"), orange: true)
            case .regular:
                self.configureOverlay(response.message, textColor: #colorLiteral(red: 0.003053205786, green: 0.692053318, blue: 0.3124624491, alpha: 1), overlayTint: #colorLiteral(red: 0.003053205786, green: 0.692053318, blue: 0.3124624491, alpha: 0.2), image: #imageLiteral(resourceName: "green_check"), orange: false)
            case .none:
                self.configureOverlay(response.message, textColor: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), overlayTint: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.2), image: #imageLiteral(resourceName: "red_cross"), orange: false)
            }
        }
    }
    
    func legiCheckFailed(_ error: String, statusCode: Int) {
        DispatchQueue.main.async {
            self.configureOverlay(error, textColor: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), overlayTint: #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.2), image: #imageLiteral(resourceName: "red_cross"), orange: false)
        }
    }
    
    func checkLegiError(_ message: String) {
        debugPrint(message)
    }
}

// MARK: - CheckEventDetailsRequestDelegate protocol extension
extension BarcodeScanViewController: CheckEventDetailsRequestDelegate {
    
    func eventDetailsCheckSuccess(_ eventDetail: EventDetail) {
        self.eventDetail = eventDetail
    }
    
    func eventDetailsCheckFailed(_ error: String, statusCode: Int) {
        debugPrint("Event Detail check failed")
    }
    
    func checkEventDetailsError(_ message: String) {
        debugPrint(message)
        self.captureSession.startRunning()
    }
}

// MARK: - UITextFieldDelegate protocol extension
extension BarcodeScanViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.SubmitButtonTapped(self)
        return true
    }
}

