//
//  QRCodeViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//  This code was based of code from https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code

import AVKit
import CoreLocation
import UIKit

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    // MARK: - Properties
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer?
    var appDelegate: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)
    @IBOutlet var qrCodeOverlay: UIImageView!
    
    // Alert strings
    let noCameraTitle = "No camera found"
    let noCameraMessage = "No camera is available for use on your device."
    let noAccessTitle = "QR code scanning unavailable"
    let noAccessMessage = "Please ensure that this app has access to your camera."
    let invalidQRCodeTitle = "Invalid QR code"
    let invalidQRCodeMessage = "The scanned QR code is not a valid QR code for a tree."
    let scanErrorTitle = "Error"
    let scanErrorMessage = "QR code could not be scanned."
    let dataSourceDisabledTitle = "Data source disabled"
    let noTreesTitle = "No trees found"
    let noTreesMessage = "No tree with the scanned code was found."

    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a capture session
        captureSession = AVCaptureSession()
        
        // Get the default video capture device
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        // Set up a capture input
        let videoInput: AVCaptureInput
        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch { return }
        
        // Add the input to the capture session
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else { return }
        
        // Set up metadata output and add it to the capture session
        let metadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else { return }
        
        // Set up the layer in which the video is displayed
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.frame = view.layer.bounds
        previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspect
        
        // Set up the QR code overlay
        qrCodeOverlay.alpha = 0.5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            self.startCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    if granted {
                        self.startCaptureSession()
                    }
                }
            })
        default:
            break
        }
    }
    
    override func viewWillDisappear(_: Bool) {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    override func viewWillAppear(_: Bool) {
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
    }
    
    override func viewWillLayoutSubviews() {
        // Only change the orientation if there is a AVCaptureVideoPreviewLayer. This prevents the app from crashing due to the forced unwrapping of the previewLayer variable
        guard previewLayer != nil else {
            return
        }
        
        // Change the orientation of the QR scanner
        guard let AVConnection: AVCaptureConnection = previewLayer!.connection else {
            return
        }
        let currentOrientation: UIDeviceOrientation = UIDevice.current.orientation
        
        switch currentOrientation {
        case UIDeviceOrientation.landscapeLeft:
            AVConnection.videoOrientation = AVCaptureVideoOrientation.landscapeRight
        case UIDeviceOrientation.portrait:
            AVConnection.videoOrientation = AVCaptureVideoOrientation.portrait
        case UIDeviceOrientation.landscapeRight:
            AVConnection.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
        default:
            AVConnection.videoOrientation = AVCaptureVideoOrientation.portrait
        }
        
        // Change the space the QR scanner occupies
        previewLayer!.frame = view.layer.bounds
    }

    /// This function takes the String that was encoded in the QR code, finds a tree that corresponds to that code using a call to getTreeFromString, and displays the results.
    func metadataOutput(_: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from _: AVCaptureConnection) {
        if let metadatObject: AVMetadataObject = metadataObjects.first {
            guard let readableObject = metadatObject as? AVMetadataMachineReadableCodeObject else {
                alertUser(title: scanErrorTitle, message: scanErrorMessage)
                return
            }

            guard let stringOutput: String = readableObject.stringValue else {
                alertUser(title: scanErrorTitle, message: scanErrorMessage)
                return
            }

            guard let treeToDisplay: Tree = getTreeFromString(encodedString: stringOutput) else {
                alertUser(title: invalidQRCodeTitle, message: invalidQRCodeMessage)
                return
            }

            captureSession.stopRunning()
            
            // Display tree data
            let pages = TreeDetailPageViewController(tree: treeToDisplay)
            navigationController?.pushViewController(pages, animated: true)
        }
    }
    
    // MARK: - Private methods

    /**
     Gets the tree that corresponds to the given encoded string. A valid string has the format "[latitude],[longitude],[database name]".
      - Parameter encodedString: The encoded string.
      - Returns: The Tree object that corresponds to the given string.
     */
    private func getTreeFromString(encodedString: String) -> Tree? {
        // Split the encoded string on the first two commas
        let resultParts: [Substring] = encodedString.split(separator: ",", maxSplits: 2, omittingEmptySubsequences: false)
        
        // If there are not three parts, alert the user
        if resultParts.count != 3 {
            alertUser(title: invalidQRCodeTitle, message: invalidQRCodeMessage)
            return nil
        }

        // Get the latitude, longitude, and data source name from each of the three portions of the string
        guard let treeLatitude: Double = Double(String(resultParts[0])) else {
            alertUser(title: invalidQRCodeTitle, message: invalidQRCodeMessage)
            return nil
        }
        guard let treeLongitude: Double = Double(String(resultParts[1])) else {
            alertUser(title: invalidQRCodeTitle, message: invalidQRCodeMessage)
            return nil
        }
        let dataSourceName: String = String(resultParts[2])

        // Find the data source with the data source name encoded int the QR code
        let treeCoordinates = CLLocationCoordinate2D(latitude: treeLatitude, longitude: treeLongitude)
        guard let dataSourceToSearch: DataSource = appDelegate.getDataSourceWithName(name: dataSourceName) else {
            alertUser(title: invalidQRCodeTitle, message: invalidQRCodeMessage)
            return nil
        }

        // Check if the data source with the given name is active
        guard appDelegate.isActive(dataSourceName: dataSourceName) else {
            alertUser(title: dataSourceDisabledTitle, message: "The data source that contains the data for this tree is currently turned off. You can turn on \"" + String(dataSourceName) + "\" in the settings.")
            return nil
        }

        guard let resultTree: Tree = TreeFinder.findTreeByLocation(location: treeCoordinates, dataSources: [dataSourceToSearch], cutoffDistance: 0.5) else {
            alertUser(title: noTreesTitle, message: noTreesMessage)
            return nil
        }

        return resultTree
    }

    /**
     Displays an alert with the given title and message and an "OK" button.
     - Parameter title: The title of the alert.
     - Parameter message: The message of the alert.
     */
    private func alertUser(title: String, message: String) {
        appDelegate.alertUser(title: title, message: message)
    }
    
    private func startCaptureSession() {
        // Start the capture session
        self.view.layer.addSublayer(self.previewLayer!)
        self.view.bringSubviewToFront(self.qrCodeOverlay)
        self.captureSession.startRunning()
    }
}
