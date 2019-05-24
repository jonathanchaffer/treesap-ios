//
//  AppDelegate.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Properties
    var window: UIWindow?
    /// Array of data sources.
    var dataSources = [DataSource]()
    /// Whether location features are enabled.
    var locationFeaturesEnabled = false
    /// Whether the user's location should be shown on the map.
    var showingUserLocation = true
    /// The max distance from which trees can be identified via coordinates or GPS.
    var cutoffDistance: Double = 100.0

    // MARK: App delegate methods
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
		self.importTreeData()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Other methods
    
    /**
     Create data sources and import their tree data.
     */
    func importTreeData() {
		self.dataSources.append(DataSource(internetFilename: "CoH_Tree_Inventory_6_12_18.csv", localFilename: "holland.csv", dataSourceName: "City of Holland", csvFormat: CSVFormat.holland, isActive: true))
        self.dataSources.append(DataSource(internetFilename: "iTreeExport_119_HopeTrees_7may2018.csv", localFilename: "itree.csv", dataSourceName: "iTree", csvFormat: CSVFormat.itree, isActive: true))
        self.dataSources.append(DataSource(internetFilename: "dataExport_119_HopeTrees_7may2018.csv", localFilename: "hope.csv", dataSourceName: "Hope College", csvFormat: CSVFormat.hope, isActive: true))
        for dataSource in self.dataSources {
            if !dataSource.retrieveOnlineData() {
                print("Error retrieving " + dataSource.dataSourceName + " data from online")
            }
        }
    }
    
    // TODO: should be renamed to getActiveDataSources
    func getDataSources() -> [DataSource]{
        var activeDataSources = [DataSource]()
        for dataSource in dataSources {
            if dataSource.isActive {
                activeDataSources.append(dataSource)
            }
        }
        return activeDataSources
    }
    
    func enableLocationFeatures() {
        self.locationFeaturesEnabled = true
    }
    
    func disableLocationFeatures() {
        self.locationFeaturesEnabled = false
    }
    
    func toggleShowingUserLocation() {
        if self.showingUserLocation {
            self.showingUserLocation = false
        } else {
            self.showingUserLocation = true
        }
    }
}

