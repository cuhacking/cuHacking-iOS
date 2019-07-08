//
//  QRScannerViewController.swift
//  cuHacking
//
//  Created by Santos on 2019-06-28.
//  Copyright © 2019 cuHacking. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerViewController : CUViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession : AVCaptureSession!
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.makeTransparent()
        if(captureSession?.isRunning == false){
            captureSession.startRunning()
        }
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        verifyCameraPermission()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.tabBarController?.tabBar.isHidden = false
        self.navigationController?.undoTransparent()
        if(captureSession?.isRunning == true){
            captureSession.stopRunning()
        }
        super.viewWillDisappear(animated)
    }

    private func setupCamera(){
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            showCameraSetupFailedAlert(title: "QR Scanning not Supported", message: "Permission to use the camera was denied. Please go to your system settings and give cuHacking permission inorder to scan QR codes. ")
            return
        }
        let videoInput : AVCaptureDeviceInput
        do{
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }
        catch {
            print(error.localizedDescription)
            return
        }
        if captureSession.canAddInput(videoInput){
            captureSession.addInput(videoInput)
        }
        else{
            showCameraSetupFailedAlert(title: "QR Scanning not Supported", message: "Permission to use the camera was denied. Please go to your system settings and give cuHacking permission inorder to scan QR codes.")
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if(captureSession.canAddOutput(metadataOutput)){
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
        else{
            showCameraSetupFailedAlert(title: "QR Scanning not Supported", message: "Permission to use the camera was denied. Please go to your system settings and give cuHacking permission inorder to scan QR codes. ")
            return
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
        
    }
    
    private func verifyCameraPermission(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                }
                else{
                    DispatchQueue.main.async {
                      self.showCameraSetupFailedAlert(title: "Can't Access Camera", message: "Permission to use the camera was denied. Please go to your system settings and give cuHacking permission inorder to scan QR codes.")
                    }
                }
            }
            break
        case .denied:
            showCameraSetupFailedAlert(title: "Can't Access Camera", message: "Permission to use the camera was denied. Please go to your system settings and give cuHacking permission inorder to scan QR codes.")
            break
        case .restricted:
            showCameraSetupFailedAlert(title: "Restriced Camera Access", message: "Camera usage is restricted on this device.")
            break
        default:
            break
        }
    }
    
    private func showCameraSetupFailedAlert(title: String, message: String){
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.navigationController?.popViewController(animated: false)
        }
        errorAlert.addAction(okAction)
        present(errorAlert, animated: false)
        captureSession = nil
    }
    
    private func found(code:String){
        print("Found code:\(code)")
    }
    
    //MARK: AVCaptureMetadataOutputObjectsDelegate Methods
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        dismiss(animated: true)
    }
}

