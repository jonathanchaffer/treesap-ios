//
//  LoadingScreenViewController.swift
//  TreeSapIOS
//
//  Created by Research on 6/5/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import UIKit

class LoadingScreenViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidAppear(_: Bool) {
        // Try loading local data
        let allLocalDataLoaded = appDelegate.importLocalTreeData()
        // If all local data was loaded properly, show the home screen and start importing online tree data in the background. Otherwise, stay in the loading screen until the tree data from online repositories is loaded
        if allLocalDataLoaded {
            loadHomeScreen()
            appDelegate.importOnlineTreeData(loadingScreenActive: false)
        } else {
            appDelegate.importOnlineTreeData(loadingScreenActive: true)
        }
    }

    // TODO: Rename to showHomeScreen
    /**
     Shows the home screen. If the parameter indicates that the local data could not be loaded, alerts the user upon loading the home screen. Used https://coderwall.com/p/cjuzng/swift-instantiate-a-view-controller-using-its-storyboard-name-in-xcode as a reference.
     - Parameter localDataLoaded: Whether all of the local data was loaded properly. If false, the user is alerted.
     */
    func loadHomeScreen() {
        let tabBarController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarController")
        tabBarController.modalTransitionStyle = .crossDissolve
        show(tabBarController, sender: self)
    }
}
