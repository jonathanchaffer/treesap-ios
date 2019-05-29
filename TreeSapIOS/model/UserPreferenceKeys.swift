//
//  UserPreferenceKeys.swift
//  TreeSapIOS
//
//  Created by CS Student on 5/29/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

///Used to store the keys that are used to store the user preferences and default preferences
struct UserPreferenceKeys{
    //Keys used for storage
    let cutoffDistanceKey = "cutoffDistanceKey"
    let dataSourceAvailibilityKey = "dataSourcesAvailibilityKey"
    let showUserLocationKey = "showUserLocationKey"
    
    //constants that store the default preferences
    let cutoffdistanceDefault = 100.0
    let dataSourceAvailibilityDefault = ["City of Holland Tree Inventory": true, "Hope College i-Tree Data": true, "Hope College Trees": true]
    let showUserLocation = true
    
    //variables that store the current user preferences
    var cutoffDistance: Double
    var dataSourceAvailibility: [String: bool]
    var showUserLocation: Bool
}
