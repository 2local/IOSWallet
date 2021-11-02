//
//  QRScannerView.swift
//  QRCodeReader
//
//  Created by KM, Abhilash a on 08/03/19.
//  Copyright © 2019 KM, Abhilash. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import KVNProgress
/// Delegate callback for the QRScannerView.
protocol QRScannerViewDelegate: class {
    func qrScanningDidFail()
    func qrScanningSucceededWithCode(_ str: String?)
    func qrScanningDidStop()
}

class QRScannerView: UIView {
    
    weak var delegate: QRScannerViewDelegate?
    
    /// capture settion which allows us to start and stop scanning.
    var captureSession: AVCaptureSession?
    
    // Init methods..
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        doInitialSetup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        doInitialSetup()
    }
    
    //MARK: overriding the layerClass to return `AVCaptureVideoPreviewLayer`.
    override class var layerClass: AnyClass  {
        return AVCaptureVideoPreviewLayer.self
    }
    override var layer: AVCaptureVideoPreviewLayer {
        
        return super.layer as! AVCaptureVideoPreviewLayer
    }
}
extension QRScannerView {
    
    var isRunning: Bool {
        return captureSession?.isRunning ?? false
    }
    
    func startScanning() {
       captureSession?.startRunning()
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
        delegate?.qrScanningDidStop()
    }
    
    /// Does the initial setup for captureSession
    private func doInitialSetup() {
        clipsToBounds = true
        captureSession = AVCaptureSession()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                DispatchQueue.main.async {
                    guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
                    let videoInput: AVCaptureDeviceInput
                    do {
                        videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
                    } catch let error {
                        print(error)
                        return
                    }
                    
                    if (self.captureSession?.canAddInput(videoInput) ?? false) {
                        self.captureSession?.addInput(videoInput)
                    } else {
                        self.scanningDidFail()
                        return
                    }
                    
                    let metadataOutput = AVCaptureMetadataOutput()
                    
                    if (self.captureSession?.canAddOutput(metadataOutput) ?? false) {
                        self.captureSession?.addOutput(metadataOutput)
                        
                        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
                    } else {
                        self.scanningDidFail()
                        return
                    }
                    
                    self.layer.session = self.captureSession
                    self.layer.videoGravity = .resizeAspectFill
                    self.captureSession?.startRunning()
                }
                
            } else {
                DispatchQueue.main.async {
                    let alertController = UIAlertController (title: "Camera Access", message: "You didn't Access to camera\nPlease access from settings", preferredStyle: .alert)

                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }

                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                            })
                        }
                    }
                    alertController.addAction(settingsAction)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
                        self.parentController(of: ScanViewController.self)?.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(cancelAction)

                    self.parentController(of: ScanViewController.self)?.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
    }
    func scanningDidFail() {
        delegate?.qrScanningDidFail()
        captureSession = nil
    }
    
    func found(code: String) {
        delegate?.qrScanningSucceededWithCode(code)
    }
    
}
extension UIResponder {
    func parentController<T: UIViewController>(of type: T.Type) -> T? {
        guard let next = self.next else {
            return nil
        }
        return (next as? T) ?? next.parentController(of: T.self)
    }
}

extension QRScannerView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        //stopScanning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            //AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
    
}
