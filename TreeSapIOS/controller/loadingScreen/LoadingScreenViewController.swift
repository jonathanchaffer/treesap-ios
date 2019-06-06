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
        //Check if there is internet access
        
        // Load trees, assumming there is internet access. If tree data could be loaded adequately from local repositories, exit the loading screen before loading tree data from online repositories. Otherwise, stay in the loading screen until the tree data from online repositories is loaded.
        let allDataSourcesLoaded = appDelegate.importLocalTreeData()
        if(allDataSourcesLoaded){
            loadHomeScreen(localDataLoaded: true)
            appDelegate.importOnlineTreeData()
        }else{
            appDelegate.importOnlineTreeData()
        }
        
        //Load trees, assumming there is no internet access
    }
    
    /**
     Loads the home screen. If the parameter indicates that the local data could not be loaded, alerts the user upon loading the home screen.  Made using code from https://coderwall.com/p/cjuzng/swift-instantiate-a-view-controller-using-its-storyboard-name-in-xcode as a reference.
     - Parameter localDataLoaded: Whether all of the local data was loaded properly. If false, the user is alerted.
     */
    func loadHomeScreen(localDataLoaded: Bool){
        //Load home screen
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "tabBarController")
        self.show(tabBarController, sender: self)
        
        //If not all of the local data was loaded alert the user
        if(!localDataLoaded){
            let alertController = UIAlertController(title: "", message: "Some of the tree information could not be loaded", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            tabBarController.present(alertController, animated: true, completion: nil)
        }
    }
}
