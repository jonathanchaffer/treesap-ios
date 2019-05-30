//
//  UserPreferences.swift
//  TreeSapIOS
//
//  Created by CS Student on 5/24/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//
//  ** Not used **
//

import Foundation

//Based on code from https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/PersistData.html#//apple_ref/doc/uid/TP40015214-CH14-SW1
///Used to encode and decode the users preferences
class UserPreferences: NSCoder, NSCoding {
    ///The maximum distance a tree can be from the location used in a search and still be found in the search
    var cutoffDistance: Double
    ///A dictionary that maps the names of data sources to booleans that indicate whether or not the data sources are active
    var dataSources: [String: Bool]
    ///Whether or not the user's location will be shown on the map
    var showUserLocation: Bool
    
    //properties that store defaults
    ///default value for cutoffDistance property
    private static let cutoffDistanceDefault: Double = 100.0
    ///default value for dataSources property
    private static let dataSourcesDefault: [String: Bool] = ["City of Holland Tree Inventory": true, "Hope College i-Tree Data": true, "Hope College Trees": true]
    ///Default value for showUserLocation property
    private static let showUserLocationDefault: Bool = true
    
    ///This contains the strings that should be used as keys to encode and decode the instance variable of the UserPreferences class
    struct preferenceKeys{
        static let maxIDDistance = "masIDDistance"
        static let dataSources = "dataSources"
        static let showLocation = "showLocation"
    }
    
    
    ///Used to make and instance of the UserPreferences class with the specified user preferences
    init(maxIDDistance: Double, dataSources: [String: Bool], showLocation: Bool) {
        self.cutoffDistance = maxIDDistance
        self.dataSources = dataSources
        self.showUserLocation = showLocation
        super.init()
    }
    
    ///Used to make an instance of the UserPreferences class using the encoded user prefences
    required init?(coder aDecoder: NSCoder) {
        cutoffDistance = aDecoder.decodeDouble(forKey: preferenceKeys.maxIDDistance)
        guard let tempDataSources = aDecoder.decodeObject(forKey: preferenceKeys.dataSources) as? [String: Bool] else{
            return nil
        }
        dataSources = tempDataSources
        showUserLocation = aDecoder.decodeBool(forKey: preferenceKeys.showLocation)
        super.init()
    }
    
    ///Used to make an instance of the UserPreferences class with the default user preferences
    override init(){
        cutoffDistance = UserPreferences.cutoffDistanceDefault
        dataSources = UserPreferences.dataSourcesDefault
        showUserLocation = UserPreferences.showUserLocationDefault
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cutoffDistance, forKey: preferenceKeys.maxIDDistance)
        aCoder.encode(dataSources, forKey: preferenceKeys.dataSources)
        aCoder.encode(showUserLocation, forKey: preferenceKeys.showLocation)
    }
}
