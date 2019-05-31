//
//  MoreInformationViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer on 5/20/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class MoreInformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openITreeWebTools(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.itreetools.org")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func openNationalTreeBenefitCalculator(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.treebenefits.com/calculator/index.cfm")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func openINaturalist(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://www.inaturalist.org")! as URL, options: [:], completionHandler: nil)
    }
}
