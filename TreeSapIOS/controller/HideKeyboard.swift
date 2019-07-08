//
//  HideKeyboard.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import UIKit

/// Extension that hides the keyboard when it is tapped outside. Simply add 'self.hideKeyboardWhenTappedAround()' to viewDidLoad to bring this behavior into effect.
extension UIViewController: UIGestureRecognizerDelegate {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(sender:)))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    public func gestureRecognizer(_: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchView = touch.view
        if touchView == nil {
            return true
        }
        // If the touch view is a subview of a text field or is a text field, then the keyboard should stay up.
        if touchView?.superview is UITextField || touchView is UITextField {
            return false
        }
        return true
    }

    /// Dismisses the keyboard.
    @objc func dismissKeyboard(sender _: UITapGestureRecognizer) {
        // The dispatch queue is used because button presses need to be resolved before the keyboard is dismissed.
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.view.endEditing(true)
        }
    }
}
