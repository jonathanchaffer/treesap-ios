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

    /// Array that stores the result of a data task that reads tree data from an online file to a local file. Each element in the array is a tuple that contains the name of the data source and a Bool that indicates whether the loading of data was successful.
    var reportedData = [(name: String, success: Bool)]()

    /// Indicates whether location features are enabled. NOTE: This is not a user preference; it is a flag that keeps track of whether the user has allowed access to device location.
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

        // Load user preferences
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
    func restoreDefaultUserPreferences() {
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
     - Parameter dataSourceName: The name of the data source.
     - Returns: A Bool indicating whether the data source is active.
     */
    func isActive(dataSourceName: String) -> Bool {
        if UserPreferenceKeys.dataSourceAvailibility[dataSourceName] == nil {
            return false
        }
        return UserPreferenceKeys.dataSourceAvailibility[dataSourceName]!
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
    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
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

    // MARK: - Data loading methods

    /**
     Imports each data source's tree data from online.
     - Parameter loadingScreenActive: Whether the loading screen is active.
     */
    func importOnlineTreeData(loadingScreenActive: Bool) {
        for dataSource in dataSources {
            dataSource.retrieveOnlineData(loadingScreenActive: loadingScreenActive)
        }
        return
    }

    /**
     Creates Tree objects in each DataSource object using data from the local tree data repositiories.
     - Returns: A Bool that indicates whether each of the data sources contained some data.
     */
    func importLocalTreeData() -> Bool {
        var allDataPresent = true // indicates whether any of the data sources contain no data (which indicates they could not be loaded)
        for dataSource in dataSources {
            if !dataSource.createTrees() {
                allDataPresent = false
            }
        }
        return allDataPresent
    }

    /// Calls handleDataLoadingReportWithLoadingScreen with the given parameters if the loadingScreenActive parameter is true and calls handleDataLoadingReportWithNoLoadingScreen with the given parameters of if the loadingScreenActive if it is false
    func handleDataLoadingReport(dataSourceName: String, success: Bool, loadingScreenActive: Bool) {
        if loadingScreenActive {
            handleDataLoadingReportWithLoadingScreen(dataSourceName: dataSourceName, success: success)
        } else {
            handleDataLoadingReportWithNoLoadingScreen(dataSourceName: dataSourceName, success: success)
        }
    }

    /**
     Stores the details of a data task that loads tree data from an online. If all of the data tasks that load information from the online data sources have finished, then this function iterates through the result of each of the data tasks and alerts the user if less than all of the data could be loaded properly.
     - Parameter dataSourceName: The name of the data source that the data task is loading information from.
     - Parameter success: Whether the data task successfully loaded tree data from the online file into the local file.
     */
    func handleDataLoadingReportWithNoLoadingScreen(dataSourceName: String, success: Bool) {
        reportedData.append((dataSourceName, success))
        if reportedData.count != dataSources.count {
            return
        }

        for (_, resultsLoaded) in reportedData {
            if !resultsLoaded {
                DispatchQueue.main.async {
                    self.alertUser(title: "Online tree data unavailable", message: "Some or all of the online tree data could not be loaded. The tree data stored on your device will be used instead.")
                }
                return
            }
        }
    }

    /**
     Stores the details of a data task that loads tree data from an online. If all of the data tasks that load information from the online data sources have finished, then this function iterates through the result of each of the data tasks and checks if any of them did not load properly. If any did not load properly, the home screen is made the "active screen" if the loading screen is the "active screen" and the user is alerted.
     - Parameter dataSourceName: The name of the data source that the data task is loading information from.
     - Parameter success: Whether the data task successfully loaded tree data from the online file into the local file.
     */
    func handleDataLoadingReportWithLoadingScreen(dataSourceName: String, success: Bool) {
        reportedData.append((dataSourceName, success))
        if reportedData.count != dataSources.count {
            return
        }

        for (_, resultsLoaded) in reportedData {
            // If there are any issues with loading the onlie data, go to the home screen and alert the user
            if !resultsLoaded {
                DispatchQueue.main.async {
                    let currentViewController = UIApplication.shared.keyWindow?.rootViewController as? LoadingScreenViewController
                    if currentViewController != nil {
                        currentViewController!.loadHomeScreen()
                    }

                    self.alertUser(title: "Some tree data unavailable", message: "Some or all of the tree data could not be loaded. Please make sure that your device is connected to the Internet and then restart the app.")
                    return
                }
            }
        }

        // If there are not issues with loading the online data, go to the home screen
        DispatchQueue.main.async {
            guard let currentViewController = UIApplication.shared.keyWindow?.rootViewController as? LoadingScreenViewController else {
                return
            }
            currentViewController.loadHomeScreen()
        }
    }

    // MARK: - Other methods

    /// Resets the state of the app for UI testing purposes.
    func resetState() {
        let defaultsName = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: defaultsName)
    }

    /**
     - Parameter name: The name of the data source to retrieve.
     - Returns: The DataSource with the given name.
     */
    func getDataSourceWithName(name: String) -> DataSource? {
        for dataSource in dataSources {
            if dataSource.dataSourceName == name {
                return dataSource
            }
        }

        return nil
    }

    /**
     Makes an alert appear with the given argument and message on the currently active UIViewController. The alert will have an "OK" buton.

     - Parameter title: The title of the alert.
     - Parameter message: The message of the alert.
     */
    func alertUser(title: String, message: String) {
        // Create an alert
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // Get the currently active UIViewController
        let currentViewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController

        if currentViewController != nil {
            currentViewController!.present(alertController, animated: true, completion: nil)
        }
    }
}
