//
//  QRCodeViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//  This code was based of code from https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code

import UIKit
import AVKit

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var appDelegate: AppDelegate!
    
    //creates the QR code scanner and makes it start capturing input
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        captureSession = AVCaptureSession()
        
        //get default video capture device
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else{
            alertUser(title: "", message: "No camera is available for use on your device.")
            return
        }
        
        //set up an audio-visual capture input
        let videoInput: AVCaptureInput
        do{
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
        }
        catch{
            alertUser(title: "", message: "QR Scanning is not available. Please make sure that this app has access to your camera in the settings on your device.")
            return
        }
        
        //add the input to the capture session
        if(captureSession.canAddInput(videoInput)){
            captureSession.addInput(videoInput)
        }
        else{
            alertUser(title: "", message: "QR Scanning is not available. Please make sure that this app has access to your camera in the settings on your device.")
            return
        }
        
        //set up metadata output and add it to the capture session
        let metadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
        if(captureSession.canAddOutput(metadataOutput)){
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
        else{
            alertUser(title: "", message: "QR Scanning is not available. Please make sure that this app has access to your camera in the settings on your device.")
            return
        }
        
        //sets up the layer in which the video is displayed
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    /// Makes an alert appear with the given argument and message. The alert will have an "Ok" buton
    func alertUser(title: String, message: String){
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadatObject: AVMetadataObject = metadataObjects.first{
            guard let readableObject = metadatObject as? AVMetadataMachineReadableCodeObject else{
                alertUser(title: "Error", message: "QR code coud not be scanned")
                return
            }
            
            guard let stringOutput: String = readableObject.stringValue else{
                alertUser(title: "Error", message: "QR code coud not be scanned")
                return
            }
            
            getTreeFromString(stringResult: stringOutput)
        }
    }
    
    func getTreeFromString(stringResult: String){
        alertUser(title: "Result", message: stringResult)
        
        //get index of underscore that separates the tree ID and the data source
        //let underscoreIndex: Int = stringResult.firstIndex(of: "_")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if(captureSession.isRunning){
            captureSession.stopRunning()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(!captureSession.isRunning){
            captureSession.startRunning()
        }
    }
    
    //change orientation of QR scanner when device rotates
    override func viewWillLayoutSubviews() {

        //change the orientation of the QR scanner
        guard let AVConnection: AVCaptureConnection = previewLayer.connection else{
            return
        }
        let currentOrientation: UIDeviceOrientation = UIDevice.current.orientation
        
        switch currentOrientation{
        case UIDeviceOrientation.landscapeLeft:
            AVConnection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        case UIDeviceOrientation.portrait:
            AVConnection.videoOrientation = AVCaptureVideoOrientation.portrait
        case UIDeviceOrientation.landscapeRight:
            AVConnection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
        default:
            AVConnection.videoOrientation = AVCaptureVideoOrientation.portrait
        }
        
        //change the space the QR scanner occupies
        previewLayer.frame = view.layer.bounds
    }
}
