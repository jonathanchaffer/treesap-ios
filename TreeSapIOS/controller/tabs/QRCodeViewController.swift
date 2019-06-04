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
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer?
    var appDelegate: AppDelegate! = (UIApplication.shared.delegate as! AppDelegate)
    @IBOutlet var QROverlay: UIImageView!

    // creates the QR code scanner and makes it start capturing input
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        // get default video capture device
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            alertUser(title: "No camera found", message: "No camera is available for use on your device.")
            return
        }

        // set up an audio-visual capture input
        let videoInput: AVCaptureInput
        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
        } catch {
            alertUser(title: "QR code scanning not available", message: "Please make sure that this app has access to your camera.")
            return
        }

        // add the input to the capture session
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            alertUser(title: "QR code scanning not available", message: "Please make sure that this app has access to your camera.")
            return
        }

        // set up metadata output and add it to the capture session
        let metadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            alertUser(title: "QR code scanning not available", message: "Please make sure that this app has access to your camera.")
            return
        }

        // sets up the layer in which the video is displayed
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer!.frame = view.layer.bounds
        previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspect
        view.layer.addSublayer(previewLayer!)

        view.bringSubviewToFront(QROverlay) // puts overlay in front of the QR scanner display
        QROverlay.alpha = 0.5

        captureSession.startRunning()
    }

    /// This function takes the String that was encoded in the QR code, finds a tree that corresponds to that code using a call to getTreeFromString, and displays the results using a call to displayTreeResults
    func metadataOutput(_: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from _: AVCaptureConnection) {
        if let metadatObject: AVMetadataObject = metadataObjects.first {
            guard let readableObject = metadatObject as? AVMetadataMachineReadableCodeObject else {
                alertUser(title: "Error", message: "QR code coud not be scanned.")
                return
            }

            guard let stringOutput: String = readableObject.stringValue else {
                alertUser(title: "Error", message: "QR code could not be scanned.")
                return
            }

            guard let resultTree: Tree = getTreeFromString(stringResult: stringOutput) else {
                alertUser(title: "No trees found", message: "No tree with the scanned code was found.")
                return
            }

            captureSession.stopRunning()
            displayTreeResults(tree: resultTree)
        }
    }

    /**
     Gets the tree that corresponds to the given encoded String. A valid string has the format "[latitude],[longitude],[database name]" (without the quotation marks or square brackets).

      - Parameter stringResult: the encodedString

      - Returns: the Tree object that corresponds to the given String
     */
    func getTreeFromString(stringResult: String) -> Tree? {
        // Split the encoded string on the first two commas
        let resultParts: [Substring] = stringResult.split(separator: ",", maxSplits: 2, omittingEmptySubsequences: false)
        if resultParts.count != 3 {
            alertUser(title: "No trees found", message: "The scanned code is not the code for a tree.")
            return nil
        }

        // get the latitude, longitude, and data source name from each of the three portions of the string
        guard let treeLatitude: Double = Double(String(resultParts[0])) else {
            alertUser(title: "No trees found", message: "The scanned code is not the code for a tree.")
            return nil
        }
        guard let treeLongitude: Double = Double(String(resultParts[1])) else {
            alertUser(title: "No trees found", message: "The scanned code is not the code for a tree.")
            return nil
        }
        let dataSourceName: String = String(resultParts[2])

        // Find the data source with the data source name encoded int the QR code
        let treeCoordinates = CLLocationCoordinate2D(latitude: treeLatitude, longitude: treeLongitude)
        guard let dataSourceToSearch: DataSource = appDelegate.getDataSourceWithName(name: dataSourceName) else {
            alertUser(title: "No trees found", message: "The scanned code is not the code for a tree")
            return nil
        }

        // Check if the data source with the given name is active
        guard appDelegate.isActive(dataSource: dataSourceName) else {
            alertUser(title: "Data source disabled", message: "The data source that contains the data for this tree is currently turned off. You can turn on \"" + String(dataSourceName) + "\" in the settings.")
            return nil
        }

        guard let resultTree: Tree = TreeFinder.findTreeByLocation(location: treeCoordinates, dataSources: [dataSourceToSearch], cutoffDistance: appDelegate.cutoffDistance) else {
            alertUser(title: "No trees found", message: "No tree with the scanned code was found.")
            return nil
        }

        return resultTree
    }

    /**
     Brings up the tree display for the given Tree object

     - Parameter tree: the Tree object that contains the tree data to display
     */
    func displayTreeResults(tree: Tree) {
        let pages = TreeDetailPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pages.displayedTree = tree
        navigationController?.pushViewController(pages, animated: true)
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

    // change orientation of QR scanner when device rotates
    override func viewWillLayoutSubviews() {
        // Only change the orientation if there is a AVCaptureVideoPreviewLayer. This prevents the app from crashing due to the forced unwrapping of the previewLayer variable
        guard previewLayer != nil else {
            return
        }

        // Change the orientation of the QR scanner
        guard let AVConnection: AVCaptureConnection = previewLayer!.connection else { // MARK: error here
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

    /**
     Makes an alert appear with the given argument and message. The alert will have an "OK" buton

     - Parameters:
        - title: the title of the alert
        - message: the message of the alert
     */
    func alertUser(title: String, message: String) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
