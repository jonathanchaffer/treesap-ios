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
        sideMenuManager.menuPushStyle = .popWhenPossible
        sideMenuManager.menuPresentMode = .menuSlideIn
        sideMenuManager.menuFadeStatusBar = false
    }
}
