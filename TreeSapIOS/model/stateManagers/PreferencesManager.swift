//
//  PreferencesManager.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation

class PreferencesManager {
    // MARK: - Properties

    // Preferences
    private static var showingUserLocation: Bool = defaultShowingUserLocation
    private static var cutoffDistance: Double = defaultCutoffDistance
    private static var dataSourceAvailability: [String: Bool] = defaultDataSourceAvailability

    // Keys for preference names
    private static let showingUserLocationKey = "showingUserLocation"
    private static let cutoffDistanceKey = "cutoffDistance"
    private static let dataSourceAvailabilityKey = "dataSourceAvailability"

    // Default preferences
    private static let defaultShowingUserLocation = true
    private static let defaultCutoffDistance = 100.0
    private static var defaultDataSourceAvailability: [String: Bool] {
        var dict: [String: Bool] = [:]
        for dataSource in DataManager.dataSources {
            dict[dataSource.dataSourceName] = true
        }
        return dict
    }

    // MARK: Getter functions
    
    ///- Returns: Whether or not the user's device location is shown on the map
    class func getShowingUserLocation() -> Bool{
        return PreferencesManager.showingUserLocation
    }
    
    ///- Returns: The cutoff distance to be used for tree searches
    class func getCutoffDistance() -> Double{
        return PreferencesManager.cutoffDistance
    }
    
    ///- Returns: A dictionary of the availability of each data source
    class func getDataSourceAvailability() -> [String:Bool]{
        return PreferencesManager.dataSourceAvailability
    }
    
    ///- Returns: The default value for whether the user's device location is shown on the map
    class func getDefaultShowingUserLocation() -> Bool{
        return PreferencesManager.defaultShowingUserLocation
    }
    
    ///- Returns: The default value for cutoffDistance
    class func getDefaultCutoffDistance() -> Double{
        return PreferencesManager.defaultCutoffDistance
    }
    
    ///- Returns: A dictiionary with the default availibility of each data source
    class func getDefaultDataSourceAvailability() -> [String:Bool]{
        return PreferencesManager.defaultDataSourceAvailability
    }
    
    //MARK: Other Functions
    
    /// Loads user preferences from UserDefaults.
    static func loadPreferences() {
        // Load showing user location
        let tempShowingUserLocation = UserDefaults.standard.object(forKey: showingUserLocationKey) as? Bool
        if tempShowingUserLocation == nil {
            showingUserLocation = defaultShowingUserLocation
        } else {
            showingUserLocation = tempShowingUserLocation!
        }

        // Load cutoff distance
        let tempCutoffDistance = UserDefaults.standard.double(forKey: cutoffDistanceKey)
        if tempCutoffDistance == 0 {
            cutoffDistance = defaultCutoffDistance
        } else {
            cutoffDistance = tempCutoffDistance
        }

        // Load data source availability
        let tempDataSourceAvailability = UserDefaults.standard.object(forKey: dataSourceAvailabilityKey) as? [String: Bool]
        if tempDataSourceAvailability == nil {
            dataSourceAvailability = defaultDataSourceAvailability
        } else {
            dataSourceAvailability = tempDataSourceAvailability!
        }
    }

    /// Sets the user preferences to the default settings.
    static func restoreDefaults() {
        showingUserLocation = defaultShowingUserLocation
        UserDefaults.standard.set(defaultShowingUserLocation, forKey: showingUserLocationKey)
        cutoffDistance = defaultCutoffDistance
        UserDefaults.standard.set(defaultCutoffDistance, forKey: cutoffDistanceKey)
        dataSourceAvailability = defaultDataSourceAvailability
        UserDefaults.standard.set(defaultDataSourceAvailability, forKey: dataSourceAvailabilityKey)
    }

    /**
     Toggles whether the user's location should be shown on the map.
     Note: If location features are disabled, the user's location will not be shown on the map, regardless of this setting.
     */
    static func toggleShowingUserLocation() {
        showingUserLocation = !showingUserLocation
        UserDefaults.standard.set(showingUserLocation, forKey: showingUserLocationKey)
    }

    /**
     Updates the cutoff distance preference.
     - Parameter cutoffDistance: The value the maximum distance trees will be identified via coordinates or GPS will be set to.
     */
    static func setCutoffDistance(_ newCutoffDistance: Double) {
        cutoffDistance = newCutoffDistance
        UserDefaults.standard.set(cutoffDistance, forKey: cutoffDistanceKey)
    }

    /// - Returns: An array containing the active data sources.
    static func getActiveDataSources() -> [DataSource] {
        var activeDataSources = [DataSource]()
        for dataSource in DataManager.dataSources {
            let availability: Bool? = dataSourceAvailability[dataSource.dataSourceName]
            if availability != nil, availability! {
                activeDataSources.append(dataSource)
            }
        }
        return activeDataSources
    }

    /**
     - Parameter dataSourceName: The name of the data source.
     - Returns: A Bool indicating whether the data source is active.
     */
    static func isActive(dataSourceName: String) -> Bool {
        if dataSourceAvailability[dataSourceName] == nil {
            return false
        }
        return dataSourceAvailability[dataSourceName]!
    }

    /**
     Sets the active status to true for the data source with the specified name.
     - Parameter dataSourceName: The name of the data source to be compared against the dataSourceName property of existing DataSource objects.
     */
    static func activateDataSource(dataSourceName: String) {
        if dataSourceAvailability[dataSourceName] == nil {
            dataSourceAvailability[dataSourceName] = true
        }

        dataSourceAvailability[dataSourceName] = true
        UserDefaults.standard.set(dataSourceAvailability, forKey: dataSourceAvailabilityKey)
    }

    /**
     Sets the active status to false for the data source with the specified name.
     - Parameter dataSourceName: The name of the data source to be compared against the dataSourceName property of existing DataSource objects.
     */
    static func deactivateDataSource(dataSourceName: String) {
        if dataSourceAvailability[dataSourceName] == nil {
            dataSourceAvailability[dataSourceName] = false
        }

        dataSourceAvailability[dataSourceName] = false
        UserDefaults.standard.set(dataSourceAvailability, forKey: dataSourceAvailabilityKey)
    }
}
