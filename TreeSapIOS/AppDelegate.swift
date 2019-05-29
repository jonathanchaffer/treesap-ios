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
    var showingUserLocation: Bool{
        return UserPreferenceKeys.showUserLocation
    }
    /// The max distance from which trees can be identified via coordinates or GPS.
    var cutoffDistance: Double {
        return UserPreferenceKeys.cutoffDistance
    }
    
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
    
    /// Create data sources and import their tree data.
    func importTreeData() {
        self.dataSources.append(DataSource(internetFilename: "CoH_Tree_Inventory_6_12_18.csv", localFilename: "holland.csv", dataSourceName: "City of Holland Tree Inventory", csvFormat: CSVFormat.holland, isActive: true))
        self.dataSources.append(DataSource(internetFilename: "iTreeExport_119_HopeTrees_7may2018.csv", localFilename: "itree.csv", dataSourceName: "Hope College i-Tree Data", csvFormat: CSVFormat.itree, isActive: true))
        self.dataSources.append(DataSource(internetFilename: "dataExport_119_HopeTrees_7may2018.csv", localFilename: "hope.csv", dataSourceName: "Hope College Trees", csvFormat: CSVFormat.hope, isActive: true))
        for dataSource in self.dataSources {
            if !dataSource.retrieveOnlineData() {
                print("Error retrieving " + dataSource.dataSourceName + " data from online")
            }
        }
    }
    
    // TODO: should be renamed to getActiveDataSources
    /// - Returns: An array containing the active data sources.
    func getActiveDataSources() -> [DataSource]{
        var activeDataSources = [DataSource]()
        for dataSource in dataSources {
            if UserPreferenceKeys.dataSourceAvailibility[dataSource.dataSourceName] {
                activeDataSources.append(dataSource)
            }
        }
        return activeDataSources
    }
    
    /// Enables location features so trees can be identified by GPS and the user's location can show up on the map.
    func enableLocationFeatures() {
        self.locationFeaturesEnabled = true
    }
    
    /// Disables location features so trees cannot be identified by GPS and the user's location won't show up on the map.
    func disableLocationFeatures() {
        self.locationFeaturesEnabled = false
    }
    
    /**
     Toggles whether the user's location should be shown on the map.
     Note: If location features are disabled, the user's location will not be shown on the map, regardless of this setting.
     */
    func toggleShowingUserLocation() {
        let newValue: Bool = !UserPreferenceKeys.showUserLocation
        UserPreferenceKeys.showUserLocation = newValue
        UserDefaults.standard.set(newValue, forKey: UserPreferenceKeys.showUserLocationKey)
    }
    
    /**
     Sets the active status to true for the data source with the specified name.
     - Parameters:
        - dataSourceName: The name of the data source to be compared against the dataSourceName property of existing DataSource objects.
     */
    func activateDataSource(dataSourceName: String) {
        guard UserPreferenceKeys.dataSourceAvailibility[dataSourceName] is Bool else{
            return
        }
        
        UserPreferenceKeys.dataSourceAvailibility[dataSourceName] = true
    }
    
    /**
     Sets the active status to false for the data source with the specified name.
     - Parameters:
     - dataSourceName: The name of the data source to be compared against the dataSourceName property of existing DataSource objects.
     */
    func deactivateDataSource(dataSourceName: String) {
        guard UserPreferenceKeys.dataSourceAvailibility[dataSourceName] is Bool else{
            return
        }
        
        UserPreferenceKeys.dataSourceAvailibility[dataSourceName] = false
    }
}

