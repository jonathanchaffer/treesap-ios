//
//  UserPreferenceKeys.swift
//  TreeSapIOS
//
//  Created by CS Student on 5/29/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation

///Used to store the keys that are used to store the user preferences and default preferences
struct UserPreferenceKeys{
    //Keys used for storage of user preferences
    static let cutoffDistanceKey = "cutoffDistanceKey"
    static let dataSourceAvailibilityKey = "dataSourcesAvailibilityKey"
    static let showUserLocationKey = "showUserLocationKey"
    
    //constants that store the default preferences
    static let cutoffDistanceDefault = 100.0
    static let dataSourceAvailibilityDefault = ["City of Holland Tree Inventory": true, "Hope College i-Tree Data": true, "Hope College Trees": true]
    static let showUserLocationDefault = true
    
    //variables that store the current user preferences
    static var cutoffDistance: Double = cutoffDistanceDefault
    static var dataSourceAvailibility: [String: Bool] = dataSourceAvailibilityDefault
    static var showUserLocation: Bool = showUserLocationDefault

    ///Set the user preferences to the default settings
    static func restoreDefaults(){
        cutoffDistance = cutoffDistanceDefault
        UserDefaults.standard.set(cutoffDistanceDefault, forKey: cutoffDistanceKey)
        dataSourceAvailibility = dataSourceAvailibilityDefault
        UserDefaults.standard.set(dataSourceAvailibilityDefault, forKey: dataSourceAvailibilityKey)
        showUserLocation = showUserLocationDefault
        UserDefaults.standard.set(showUserLocationDefault, forKey: showUserLocationKey)
    }
    
    ///Set the current user preferences to be the same as the stored user preferences
    static func loadPreferences(){
        cutoffDistance = UserDefaults.standard.double(forKey: cutoffDistanceKey)
        if(cutoffDistance == 0){
            cutoffDistance = cutoffDistanceDefault
        }
        
        tempDataSourceAvailibility = UserDefaults.standard.object(forKey: dataSourceAvailibilityKey)
        if(tempDataSourceAvailibility == nil){
            dataSourceAvailibility = dataSourceAvailibilityDefault
        }
        else{
            dataSourceAvailibility = tempDataSourceAvailibility
        }
        
        tempShowUserLocation = UserDefaults.standard.object(forKey: showUserLocationKey)
        if(tempShowUserLocation == nil){
            showUserLocation = showUserLocationDefault
        }
        else{
            showUserLocation = tempShowUserLocation
        }
    }
}
