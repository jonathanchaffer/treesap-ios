//
//  LoadingScreenViewController.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import UIKit

class LoadingScreenViewController: UIViewController {
    override func viewDidAppear(_: Bool) {
        // Try to load the local data. If there is local data, show the home screen. Then start importing online tree data.
        DataManager.importAllLocalTreeData()
        DataManager.importAllOnlineTreeData()
    }

    /**
     Shows the home screen. If the parameter indicates that the local data could not be loaded, alerts the user upon loading the home screen. Used https://coderwall.com/p/cjuzng/swift-instantiate-a-view-controller-using-its-storyboard-name-in-xcode as a reference.
     - Parameter localDataLoaded: Whether all of the local data was loaded properly. If false, the user is alerted.
     */
    func transitionToHomeScreen() {
        let tabBarController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarController")
        tabBarController.modalTransitionStyle = .crossDissolve
        show(tabBarController, sender: self)
        
        //If there is no internet connection, this causes an alert to be presented that informs the user that functionality will be limited due to the lack of an internet connection
        NetworkManager.setup()
    }
}
