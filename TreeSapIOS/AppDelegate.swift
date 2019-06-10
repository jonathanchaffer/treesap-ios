//
//  AppDelegate.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import MapKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    // MARK: - Properties

    var window: UIWindow?

    /// Array of data sources. This is where all data sources are initialized. Add to this array to add additional data sources.
    var dataSources: [DataSource] = [
        DataSource(internetFilename: "CoH_Tree_Inventory_6_12_18.csv", localFilename: "holland.csv", dataSourceName: "City of Holland Tree Inventory", csvFormat: .holland),
        DataSource(internetFilename: "iTreeExport_119_HopeTrees_7may2018.csv", localFilename: "itree.csv", dataSourceName: "Hope College i-Tree Data", csvFormat: .itree),
        DataSource(internetFilename: "dataExport_119_HopeTrees_7may2018.csv", localFilename: "hope.csv", dataSourceName: "Hope College Trees", csvFormat: .hope),
        DataSource(internetFilename: "katelyn.csv", localFilename: "benefits.csv", dataSourceName: "Tree Benefit Data", csvFormat: .benefits),
    ]

    /// A Bool indicating whether location features are enabled. NOTE: This is not a user preference; it is a flag that keeps track of whether the user has allowed access to device location.
    var locationFeaturesEnabled = false

    /// CLLocationManager instance for the entire app.
    let locationManager = CLLocationManager()

    // MARK: - Preferences properties

    /// Whether the user's location should be shown on the map.
    var showingUserLocation: Bool {
        return UserPreferenceKeys.showUserLocation
    }

    /// The max distance from which trees can be identified via coordinates or GPS.
    var cutoffDistance: Double {
        return UserPreferenceKeys.cutoffDistance
    }

    // MARK: - AppDelegate methods

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if CommandLine.arguments.contains("--uitesting") {
            resetState()
        }

        // Set attributes of the location manager.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
        
        //Load user preferences
        UserPreferenceKeys.loadPreferences()
        
        return true
    }

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Preferences methods

    /// - Returns: An array containing the active data sources.
    func getActiveDataSources() -> [DataSource] {
        var activeDataSources = [DataSource]()
        for dataSource in dataSources {
            let availibility: Bool? = UserPreferenceKeys.dataSourceAvailibility[dataSource.dataSourceName]
            if availibility != nil, availibility! {
                activeDataSources.append(dataSource)
            }
        }
        return activeDataSources
    }
    
    /// Changes the user preferences to the default user preferences.
    func restoreDefaultUserPreferences(){
        UserPreferenceKeys.showUserLocation = UserPreferenceKeys.showUserLocationDefault
        UserDefaults.standard.set(UserPreferenceKeys.showUserLocationDefault, forKey: UserPreferenceKeys.showUserLocationKey)
        UserPreferenceKeys.cutoffDistance = UserPreferenceKeys.cutoffDistanceDefault
        UserDefaults.standard.set(UserPreferenceKeys.cutoffDistance, forKey: UserPreferenceKeys.cutoffDistanceKey)
        UserPreferenceKeys.dataSourceAvailibility = UserPreferenceKeys.dataSourceAvailibilityDefault
        UserDefaults.standard.set(UserPreferenceKeys.dataSourceAvailibility, forKey: UserPreferenceKeys.dataSourceAvailibilityKey)
    }

    /// - Returns: Whether the user's location will be shown on the map.
    func accessShowUserLocation() -> Bool {
        return UserPreferenceKeys.showUserLocation
    }

    /// - Returns: The max distance from which trees will be identified by coordinates or GPS (the cutoff distance).
    func accessCutoffDistance() -> Double {
        return UserPreferenceKeys.cutoffDistance
    }

    /// - Returns: The dictionary that maps the database names to their availibility.
    func accessDataSourceAvailibility() -> [String: Bool] {
        return UserPreferenceKeys.dataSourceAvailibility
    }

    /// - Returns: The default preference for whether the user's location will be shown on the map.
    func accessShowUserLocationDefault() -> Bool {
        return UserPreferenceKeys.showUserLocationDefault
    }

    /// - Returns: The default value for the max distance from which trees will be identified by coordinates or GPS (the cutoff distance).
    func accessCutoffDistanceDefault() -> Double {
        return UserPreferenceKeys.cutoffDistanceDefault
    }

    /// - Returns: The dictionary that maps the database names to their default availibility.
    func accessDataSourceAvailibilityDefault() -> [String: Bool] {
        return UserPreferenceKeys.dataSourceAvailibilityDefault
    }

    /**
     Updates the cutoff distance preference.
     - Parameter cutoffDistance: The value the maximum distance trees will be identified via coordinates or GPS will be set to.
     */
    func modifyCutoffDistance(cutoffDistance: Double) {
        UserPreferenceKeys.cutoffDistance = cutoffDistance
        UserDefaults.standard.set(cutoffDistance, forKey: UserPreferenceKeys.cutoffDistanceKey)
    }

    /**
     - Parameter dataSource: the name of the data source
     - Returns: A Bool indicating whether the data source is active.
     */
    func isActive(dataSource: String) -> Bool {
        if UserPreferenceKeys.dataSourceAvailibility[dataSource] == nil {
            return false
        }
        return UserPreferenceKeys.dataSourceAvailibility[dataSource]!
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
     - Parameter dataSourceName: The name of the data source to be compared against the dataSourceName property of existing DataSource objects.
     */
    func activateDataSource(dataSourceName: String) {
        if UserPreferenceKeys.dataSourceAvailibility[dataSourceName] == nil {
            return
        }

        UserPreferenceKeys.dataSourceAvailibility[dataSourceName] = true
        UserDefaults.standard.set(UserPreferenceKeys.dataSourceAvailibility, forKey: UserPreferenceKeys.dataSourceAvailibilityKey)
    }

    /**
     Sets the active status to false for the data source with the specified name.
     - Parameter dataSourceName: The name of the data source to be compared against the dataSourceName property of existing DataSource objects.
     */
    func deactivateDataSource(dataSourceName: String) {
        if UserPreferenceKeys.dataSourceAvailibility[dataSourceName] == nil {
            return
        }

        UserPreferenceKeys.dataSourceAvailibility[dataSourceName] = false
        UserDefaults.standard.set(UserPreferenceKeys.dataSourceAvailibility, forKey: UserPreferenceKeys.dataSourceAvailibilityKey)
    }

    // MARK: - Location manager methods

    /// Checks the authorization status for user location, requesting authorization if needed.
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            return
        }
    }
    
    /// Function that is called when the location authorization status changes.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // Start updating location.
            locationFeaturesEnabled = true
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            // Stop updating location.
            locationFeaturesEnabled = false
            locationManager.stopUpdatingLocation()
        default:
            return
        }
    }

    // MARK: - Other methods

    /**
     Import each data source's tree data from online. This is done by first downloading the tree data from the online repository into local repositories, then creating Tree objects in the DataSource objects using the data in the local repositories. This is done asynchronously.
     - Parameter loadingScreenActive: Whether the loading scr
     */
    func importOnlineTreeData() {
        for dataSource in dataSources {
            if !dataSource.retrieveOnlineData() {
                //TODO: Either do something if retrieveOnlineData returns false or don't bother checking
                print("Error retrieving " + dataSource.dataSourceName + " data from online")
            }
        }
    }
    
    /**
     Creates Tree objects in each DataSource object using data from the local tree data repositiories. This is done synchronously
     - Returns: A Bool that indicates whether each of the data sources contained some data
     */
    func importLocalTreeData() -> Bool{
        var allDataPresent = true //indicates whether any of the data sources contain no data (which indicates they could not be loaded)
        for dataSource in dataSources{
            if(!dataSource.createTrees(asynchronous: false)){
                allDataPresent = false
            }
        }
        return allDataPresent
    }

    /// Resets the state of the app for UI testing purposes.
    func resetState() {
        let defaultsName = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: defaultsName)
    }

    /**
     - Parameter name: The name of the data source to find
     - Returns: a DataSource object that has the given name
     */
    func getDataSourceWithName(name: String) -> DataSource? {
        for dataSource in dataSources {
            if dataSource.dataSourceName == name {
                return dataSource
            }
        }

        return nil
    }
}
