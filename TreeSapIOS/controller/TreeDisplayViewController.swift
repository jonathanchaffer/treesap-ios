//
//  GeneralDisplayViewController.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/21/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

class TreeDisplayViewController: UIViewController {
    // MARK: Properties
    var displayedTree: Tree? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
