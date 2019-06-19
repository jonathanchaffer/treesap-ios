//
//  MoreInformationViewController.swift
//  TreeSapIOS
//
//  Created by Research on 6/19/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import UIKit

class MoreInformationViewController: UIViewController{
    
    @IBAction func openITreeWebTools(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.itreetools.org")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func openNationalTreeBenefitCalculator(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "http://www.treebenefits.com/calculator/")! as URL, options: [:], completionHandler: nil)
    }//https://www.treebenefits.com/calculator/index.cfm
    
    @IBAction func openINaturalist(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.inaturalist.org")! as URL, options: [:], completionHandler: nil)
    }
}
