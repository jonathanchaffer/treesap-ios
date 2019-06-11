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
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // Get the currently active UIViewController
        var currentViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while currentViewController?.presentedViewController != nil {
            currentViewController = currentViewController?.presentedViewController
        }

        if currentViewController != nil {
            currentViewController!.present(alertController, animated: true, completion: nil)
        }
    }
}
