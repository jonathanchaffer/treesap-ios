//
//  QRCodeViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  Used https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code as a reference.

import AVKit
import CoreLocation
import UIKit

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // MARK: - Properties

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer?
    @IBOutlet var qrCodeOverlay: UIImageView!

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

    override func viewDidAppear(_: Bool) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            startCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
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
                AlertManager.alertUser(title: StringConstants.scanErrorTitle, message: StringConstants.scanErrorMessage)
                return
            }

            guard let stringOutput: String = readableObject.stringValue else {
                AlertManager.alertUser(title: StringConstants.scanErrorTitle, message: StringConstants.scanErrorMessage)
                return
            }

            guard let treeToDisplay: Tree = getTreeFromString(encodedString: stringOutput) else {
                AlertManager.alertUser(title: StringConstants.invalidQRCodeTitle, message: StringConstants.invalidQRCodeMessage)
                return
            }

            captureSession.stopRunning()

            // Display tree data
            let pages = TreeDetailPageViewController(tree: treeToDisplay)
            navigationController?.pushViewController(pages, animated: true)
        }
    }

    // MARK: - Private functions

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
            AlertManager.alertUser(title: StringConstants.invalidQRCodeTitle, message: StringConstants.invalidQRCodeMessage)
            return nil
        }

        // Get the latitude, longitude, and data source name from each of the three portions of the string
        guard let treeLatitude: Double = Double(String(resultParts[0])) else {
            AlertManager.alertUser(title: StringConstants.invalidQRCodeTitle, message: StringConstants.invalidQRCodeMessage)
            return nil
        }
        guard let treeLongitude: Double = Double(String(resultParts[1])) else {
            AlertManager.alertUser(title: StringConstants.invalidQRCodeTitle, message: StringConstants.invalidQRCodeMessage)
            return nil
        }
        let dataSourceName: String = String(resultParts[2])

        // Find the data source with the data source name encoded int the QR code
        let treeCoordinates = CLLocationCoordinate2D(latitude: treeLatitude, longitude: treeLongitude)
        guard let dataSourceToSearch: DataSource = DataManager.getDataSourceWithName(name: dataSourceName) else {
            AlertManager.alertUser(title: StringConstants.invalidQRCodeTitle, message: StringConstants.invalidQRCodeMessage)
            return nil
        }

        // Check if the data source with the given name is active
        guard PreferencesManager.isActive(dataSourceName: dataSourceName) else {
            AlertManager.alertUser(title: StringConstants.dataSourceDisabledTitle, message: StringConstants.dataSourceDisabledMessage0 + String(dataSourceName) + StringConstants.dataSourceDisabledMessage1)
            return nil
        }

        guard let resultTree: Tree = TreeFinder.findTreeByLocation(location: treeCoordinates, dataSources: [dataSourceToSearch], cutoffDistance: 0.5) else {
            AlertManager.alertUser(title: StringConstants.noTreesFoundByQRCodeTitle, message: StringConstants.noTreesFoundByQRCodeMessage)
            return nil
        }

        return resultTree
    }

    private func startCaptureSession() {
        // Start the capture session
        view.layer.addSublayer(previewLayer!)
        view.bringSubviewToFront(qrCodeOverlay)
        captureSession.startRunning()
    }
}
