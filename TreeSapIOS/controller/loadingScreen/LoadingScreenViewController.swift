//
//  LoadingScreenViewController.swift
//  TreeSapIOS
//
//  Created by Research on 6/5/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import UIKit

class LoadingScreenViewController: UIViewController{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidAppear(_ animated: Bool) {
            // Load trees, assumming there is internet access. If tree data could be loaded adequately from local repositories, exit the loading screen before loading tree data from online repositories. Otherwise, stay in the loading screen until the tree data from online repositories is loaded.
        let allLocalDataLoaded = appDelegate.importLocalTreeData()
        if(allLocalDataLoaded){
            loadHomeScreen()
            appDelegate.importOnlineTreeData(loadingScreenActive: false)
        }else{
            appDelegate.importOnlineTreeData(loadingScreenActive: true)
        }
    }
    
    /**
     Loads the home screen. If the parameter indicates that the local data could not be loaded, alerts the user upon loading the home screen.  Made using code from https://coderwall.com/p/cjuzng/swift-instantiate-a-view-controller-using-its-storyboard-name-in-xcode as a reference.
     - Parameter localDataLoaded: Whether all of the local data was loaded properly. If false, the user is alerted.
     */
    func loadHomeScreen(){
        //Load home screen
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController")
        tabBarController.modalTransitionStyle = .crossDissolve
        self.show(tabBarController, sender: self)
    }
}
