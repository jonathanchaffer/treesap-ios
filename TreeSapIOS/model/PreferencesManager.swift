//
//  PreferencesManager.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 6/11/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation

class PreferencesManager {
    // MARK: - Properties
    
    /// Whether the user's location should be shown on the map.
    static var showingUserLocation: Bool {
        return UserPreferenceKeys.showUserLocation
    }
    
    /// The max distance from which trees can be identified via coordinates or GPS.
    static var cutoffDistance: Double {
        return UserPreferenceKeys.cutoffDistance
    }
    
    // MARK: - Static functions
    
    static func loadPreferences() {
        UserPreferenceKeys.loadPreferences()
    }
    
    /// - Returns: An array containing the active data sources.
    static func getActiveDataSources() -> [DataSource] {
        var activeDataSources = [DataSource]()
        for dataSource in DataManager.dataSources {
            let availibility: Bool? = UserPreferenceKeys.dataSourceAvailibility[dataSource.dataSourceName]
            if availibility != nil, availibility! {
                activeDataSources.append(dataSource)
            }
        }
        return activeDataSources
    }
    
    /// Changes the user preferences to the default user preferences.
    static func restoreDefaultUserPreferences() {
        UserPreferenceKeys.showUserLocation = UserPreferenceKeys.showUserLocationDefault
        UserDefaults.standard.set(UserPreferenceKeys.showUserLocationDefault, forKey: UserPreferenceKeys.showUserLocationKey)
        UserPreferenceKeys.cutoffDistance = UserPreferenceKeys.cutoffDistanceDefault
        UserDefaults.standard.set(UserPreferenceKeys.cutoffDistance, forKey: UserPreferenceKeys.cutoffDistanceKey)
        UserPreferenceKeys.dataSourceAvailibility = UserPreferenceKeys.dataSourceAvailibilityDefault
        UserDefaults.standard.set(UserPreferenceKeys.dataSourceAvailibility, forKey: UserPreferenceKeys.dataSourceAvailibilityKey)
    }
    
    /// - Returns: Whether the user's location will be shown on the map.
    static func accessShowUserLocation() -> Bool {
        return UserPreferenceKeys.showUserLocation
    }
    
    /// - Returns: The max distance from which trees will be identified by coordinates or GPS (the cutoff distance).
    static func accessCutoffDistance() -> Double {
        return UserPreferenceKeys.cutoffDistance
    }
    
    /// - Returns: The dictionary that maps the database names to their availibility.
    static func accessDataSourceAvailibility() -> [String: Bool] {
        return UserPreferenceKeys.dataSourceAvailibility
    }
    
    /// - Returns: The default preference for whether the user's location will be shown on the map.
    static func accessShowUserLocationDefault() -> Bool {
        return UserPreferenceKeys.showUserLocationDefault
    }
    
    /// - Returns: The default value for the max distance from which trees will be identified by coordinates or GPS (the cutoff distance).
    static func accessCutoffDistanceDefault() -> Double {
        return UserPreferenceKeys.cutoffDistanceDefault
    }
    
    /// - Returns: The dictionary that maps the database names to their default availibility.
    static func accessDataSourceAvailibilityDefault() -> [String: Bool] {
        return UserPreferenceKeys.dataSourceAvailibilityDefault
    }
    
    /**
     Updates the cutoff distance preference.
     - Parameter cutoffDistance: The value the maximum distance trees will be identified via coordinates or GPS will be set to.
     */
    static func modifyCutoffDistance(cutoffDistance: Double) {
        UserPreferenceKeys.cutoffDistance = cutoffDistance
        UserDefaults.standard.set(cutoffDistance, forKey: UserPreferenceKeys.cutoffDistanceKey)
    }
    
    /**
     - Parameter dataSourceName: The name of the data source.
     - Returns: A Bool indicating whether the data source is active.
     */
    static func isActive(dataSourceName: String) -> Bool {
        if UserPreferenceKeys.dataSourceAvailibility[dataSourceName] == nil {
            return false
        }
        return UserPreferenceKeys.dataSourceAvailibility[dataSourceName]!
    }
    
    /**
     Toggles whether the user's location should be shown on the map.
     Note: If location features are disabled, the user's location will not be shown on the map, regardless of this setting.
     */
    static func toggleShowingUserLocation() {
        let newValue: Bool = !UserPreferenceKeys.showUserLocation
        UserPreferenceKeys.showUserLocation = newValue
        UserDefaults.standard.set(newValue, forKey: UserPreferenceKeys.showUserLocationKey)
    }
    
    /**
     Sets the active status to true for the data source with the specified name.
     - Parameter dataSourceName: The name of the data source to be compared against the dataSourceName property of existing DataSource objects.
     */
    static func activateDataSource(dataSourceName: String) {
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
    static func deactivateDataSource(dataSourceName: String) {
        if UserPreferenceKeys.dataSourceAvailibility[dataSourceName] == nil {
            return
        }
        
        UserPreferenceKeys.dataSourceAvailibility[dataSourceName] = false
        UserDefaults.standard.set(UserPreferenceKeys.dataSourceAvailibility, forKey: UserPreferenceKeys.dataSourceAvailibilityKey)
    }
}
