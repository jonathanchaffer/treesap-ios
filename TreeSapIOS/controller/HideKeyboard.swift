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
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    ///Dismisses the keyboard.
    @objc func dismissKeyboard() {
        //The dispatch queue is used because button presses need to be resolved before the keyboard is dismissed.
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.view.endEditing(true)
        }
    }
}
