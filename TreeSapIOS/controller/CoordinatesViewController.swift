//
//  SecondViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import MapKit

class CoordinatesViewController: UIViewController {
	// MARK: Properties
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        latitudeTextField.delegate = self
        longitudeTextField.delegate = self
        
        //Set up gesture recognizer that will dismiss the keyboard when the user taps outside of it
        let gestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stopEditingText))
        gestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gestureRecognizer)
    }
	
	// MARK: Actions
	@IBAction func handleCoordinatesButtonPressed(_ sender: UIButton) {
		// Convert the inputs to Double. If the conversion failed, alert the user.
		let latitude = Double(latitudeTextField.text!)
		let longitude = Double(longitudeTextField.text!)
		if (latitude != nil && longitude != nil) {
			// If tree data was found, display it. Otherwise, alert the user.
			let treeToDisplay = self.getTreeDataByCoords(latitude: latitude!, longitude: longitude!)
			if (treeToDisplay != nil) {
				let pages = TreeDetailPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
				pages.displayedTree = treeToDisplay
				navigationController?.pushViewController(pages, animated: true)
			} else {
				let alert = UIAlertController(title: "No trees found", message: "There were no trees found near that location.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
				self.present(alert, animated: true)
			}
		} else {
			let alert = UIAlertController(title: "Invalid coordinates", message: "Please make sure that you input valid coordinates.", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
			self.present(alert, animated: true)
		}
	}
	
	// MARK: Private methods
	private func getTreeDataByCoords(latitude: Double, longitude: Double) -> Tree? {
		let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		let dataSets = appDelegate.getDataSets()
		return TreeFinder.findTree(location: location, dataSets: dataSets)
	}
    
    ///Makes all included text fields (which will probably be all the text fields that this class has as properties) stop editting, dismissing the keyboard
    @objc func stopEditingText(){
        longitudeTextField.endEditing(true)
        latitudeTextField.endEditing(true)
    }
	
}

// Extension that makes the text fields allow only numbers, dashes, and dots.
// https://stackoverflow.com/questions/30973044/how-to-restrict-uitextfield-to-take-only-numbers-in-swift
extension CoordinatesViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn:"-.0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
