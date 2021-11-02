//
//  ScanViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/31/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit
import AVFoundation
import KVNProgress

protocol ScannerDelegate: AnyObject {
    func getValue(_ value: String)
}

class ScanViewController: BaseVC, QRScannerViewDelegate {
    func qrScanningDidFail() {
        
    }
    
    func qrScanningDidStop() {
        
    }
    
    //MARK: - outlets
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet var cameraView: QRScannerView! {
        didSet {
            cameraView.delegate = self
        }
    }
    
    
    //MARK: - properties
    weak var scannerDelegate: ScannerDelegate?
    private var isFromTabbar: Bool = true
    func initWith(_ isFromTabbar: Bool) {
        self.isFromTabbar = isFromTabbar
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !cameraView.isRunning {
            DispatchQueue.main.async {
                self.cameraView.startScanning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cameraView.delegate = nil
        if cameraView.isRunning {
            cameraView.stopScanning()
        }
        
    }
    
    //MARK: - functions
    fileprivate func setupView() {
        self.parent?.view.setShadow(color: UIColor._002CA4, opacity: 0.1, offset: CGSize(width: 0, height: -3), radius: 10)
        
        setNavigation(title: "Scan", largTitle: false, foregroundColor: .white)
        
        createCloseBarButtonItem()
        
        closeButton.isHidden = isFromTabbar
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(UIImage(named: "close")?.tint(with: .white), for: .normal)
        closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
    }
    
    fileprivate func createCloseBarButtonItem() {
        let barItemButton = createButtonItems("close", colorIcon: .white, action: #selector(closeView))
        navigationItem.rightBarButtonItems = [barItemButton]
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        //QRCode Format: "WalletNumber,Amount" : GDHETQTSFSMEF5QOM5Q3OGO73DE72LLO43DJQ7DBJDKZYHP3F74IZGZH,122323
        if let str = str {
            self.prepareNavigation(str)
        }
    }
    
    @IBAction func torch(_ sender: Any) {
        toggleTorch(sender: (sender as! UIButton))
    }
    
    @IBAction func switchCamera(_ sender: Any) {
        self.switchCamera()
    }
    
    func switchCamera() {
        if let session = self.cameraView.captureSession {
            if session.inputs.count != 0 {
                let currentCameraInput: AVCaptureInput = session.inputs[0]
                
                session.removeInput(currentCameraInput)
                var newCamera: AVCaptureDevice
                newCamera = AVCaptureDevice.default(for: AVMediaType.video)!
                
                if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back {
                    UIView.transition(with: self.cameraView, duration: 0.5, options: [.transitionFlipFromLeft,.curveEaseInOut], animations: {
                        guard let frontCamera = self.cameraWithPosition(.front) else {
                            KVNProgress.showError(withStatus: "Your camera has a problem!")
                            return
                        }
                        newCamera = frontCamera
                    }, completion: nil)
                } else {
                    UIView.transition(with: self.cameraView, duration: 0.5, options: [.transitionFlipFromRight,.curveEaseInOut], animations: {
                        guard let backCamera = self.cameraWithPosition(.back) else {
                            KVNProgress.showError(withStatus: "Your camera has a problem!")
                            return
                        }
                        newCamera = backCamera
                    }, completion: nil)
                }
                do {
                    try session.addInput(AVCaptureDeviceInput(device: newCamera))
                }
                catch {
                    print("error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func cameraWithPosition(_ position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        for device in deviceDescoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    func toggleTorch(sender:UIButton) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if device.torchMode == .on {
                    device.torchMode = .off
                    UIView.animate(withDuration: 0.2) {
                        sender.backgroundColor = ._mortar
                    }
                }
                else if device.torchMode == .off {
                    device.torchMode = .on
                    UIView.animate(withDuration: 0.2) {
                        sender.backgroundColor = ._flamenco
                    }
                }
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
    
    @objc func closeView() {
        dismiss(animated: true)
    }
    
    func prepareNavigation(_ value: String) {
        if isFromTabbar {
            let stringData = value.split(separator: ",")
            if stringData.count == 2 {
                let vc = UIStoryboard.scan.instantiate(viewController: PaymentConfirmationViewController.self)
                if let navigation = navigationController {
                    navigation.pushViewController(vc, animated: true)
                }
            }
            else {
                KVNProgress.showError(withStatus: "The qr-code format is not valid")
            }
            
        } else {
            scannerDelegate?.getValue(value)
            closeView()
        }
    }
    
}
