//
//  ReadContactQRCommand.swift
//  Contact Card
//
//  Created by Ravi Vooda on 4/30/17.
//  Copyright © 2017 Utils. All rights reserved.
//

import UIKit
import AVFoundation

class ReadContactQRCommand: Command, AVCaptureMetadataOutputObjectsDelegate {
    
    let captureSession:AVCaptureSession
    let videoPreviewLayer:AVCaptureVideoPreviewLayer
    
    weak var qrController:QRReadingViewController?
    
    override init(viewController: UIViewController, returningCommand: Command?) {
        self.captureSession = AVCaptureSession()
        self.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        super.init(viewController: viewController, returningCommand: returningCommand)
    }
    
    private func reportError(message:String) {
        self.presentingViewController.showAlertMessage(message: message)
    }
    
    override func execute(completed: CommandCompleted?) {
        super.execute(completed: completed)
        
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) ==  AVAuthorizationStatus.denied {
            return self.presentingViewController.showSettingsAlertMessage(message: "Back camera is disabled for the app. Please enable camera usage in your settings")
        }
        
        do {
            let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
            let input = try AVCaptureDeviceInput.init(device: captureDevice)
            self.captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            self.captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue(label: "com.Contacts.Contact-Card.QRCodeReader"))
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            if let qrController = self.presentingViewController.storyboard?.instantiateViewController(withIdentifier: "QRReadingViewController") as? QRReadingViewController {
                self.qrController = qrController
                qrController.qrCommand = self
                self.presentingViewController.present(qrController, animated: true, completion: {
                    print(qrController.view.frame)
                    self.videoPreviewLayer.frame = qrController.view.frame
                    qrController.view.layer.addSublayer(self.videoPreviewLayer)
                    self.captureSession.startRunning()
                    qrController.view.bringSubview(toFront: qrController.cancelButton)
                    qrController.cancelButton.tintColor = .white
                })
            }
            
        } catch let error {
            self.reportError(message: error.localizedDescription)
            print("Error occurred while capturing the QR code \(error)")
        }
    }
    
    func cancelQRReading(sender:Any) {
        self.qrController?.dismiss(animated: true, completion: nil)
        self.qrController = nil
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        print("Found object : \(metadataObjects)")
        for metadataObject in metadataObjects {
            if let metadataObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                metadataObject.stringValue.contains("/share/"),
                let url = URL(string: metadataObject.stringValue){
                DispatchQueue.main.async {
                    self.qrController?.dismiss(animated: true, completion: {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    })
                    self.qrController = nil
                }
            }
        }
    }
}
