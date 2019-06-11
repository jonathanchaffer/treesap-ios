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
     Shows an alert with the given title and message on the currently active UIViewController.

     - Parameter title: The title of the alert.
     - Parameter message: The message of the alert.
     */
    static func alertUser(title: String, message: String) {
        // Create an alert
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // Get the currently active UIViewController
        let currentViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController

        if currentViewController != nil {
            currentViewController!.present(alertController, animated: true, completion: nil)
        }
    }
}
