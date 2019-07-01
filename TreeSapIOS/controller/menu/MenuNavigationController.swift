//
//  HamburgerMenu.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit
import SideMenu

class MenuNavigationController: UISideMenuNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuManager.menuPresentMode = .menuSlideIn
        sideMenuManager.menuFadeStatusBar = false
        sideMenuManager.menuAnimationFadeStrength = 0.5
        sideMenuManager.menuAnimationBackgroundColor = UIColor.darkGray
        sideMenuManager.menuAnimationTransformScaleFactor = 0.95
        sideMenuManager.menuParallaxStrength = 10
    }
}
