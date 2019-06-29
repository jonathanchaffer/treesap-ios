//
//  AlertManager.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class AlertManager {
    /**
     Shows an alert with the given title and message on the currently active UIViewController. NOTE: This is only for alerts with an "OK" button that closes the alert. If custom behavior (multiple options, button handlers, etc) is desired, you must create and present a custom alert.

     - Parameter title: The title of the alert.
     - Parameter message: The message of the alert.
     */
    static func alertUser(title: String, message: String) {
        // Create an alert
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: StringConstants.ok, style: UIAlertAction.Style.default, handler: nil))

        // Present the alert from the current view controller
        if let currentViewController = getCurrentViewController() {
            currentViewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func showLoadingAlert() {
        // Create an alert
        let loadingAlertController = UIAlertController(title: StringConstants.pleaseWait, message: nil, preferredStyle: .alert)
        
        // Present the alert from the current view controlelr
        if let currentViewController = getCurrentViewController() {
            currentViewController.present(loadingAlertController, animated: true, completion: nil)
        }
    }
    
    /// - Returns: The currently active view controller.
    fileprivate static func getCurrentViewController() -> UIViewController? {
        var currentViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while currentViewController?.presentedViewController != nil {
            currentViewController = currentViewController?.presentedViewController
        }
        return currentViewController
    }
}
