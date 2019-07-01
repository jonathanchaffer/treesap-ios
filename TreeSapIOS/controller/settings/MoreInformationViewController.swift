//
//  MoreInformationViewController.swift
//  TreeSapIOS
//
//  Created by Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import UIKit

class MoreInformationViewController: UIViewController {
    
    private func closeMoreInformation() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openITreeWebTools(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.itreetools.org")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func openNationalTreeBenefitCalculator(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "http://www.treebenefits.com/calculator/")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func openINaturalist(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.inaturalist.org")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        closeMoreInformation()
    }
    
}
