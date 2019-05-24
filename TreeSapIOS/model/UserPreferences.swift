//
//  UserPreferences.swift
//  TreeSapIOS
//
//  Created by CS Student on 5/24/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation

//Based on code from https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/PersistData.html#//apple_ref/doc/uid/TP40015214-CH14-SW1
///Used to encode and decode the users preferences
class UserPreferences: NSCoder, NSCoding {
    ///The maximum distance a tree can be from the location used in a search and still be found in the search
    var maxIDDistance: Int
    ///A dictionary that maps the names of data sources to booleans that indicate whether or not the data sources are active
    var dataSources: [String: Bool]
    ///Whether or not the user's location will be shown on the map
    var showLocation: Bool
    
    ///This contains the strings that should be used as keys to encode and decode the instance variable of the UserPreferences class
    struct preferenceKeys{
        static let maxIDDistance = "masIDDistance"
        static let dataSources = "dataSources"
        static let showLocation = "showLocation"
    }
    
    init(maxIDDistance: Int, dataSources: [String: Bool], showLocation: Bool) {
        self.maxIDDistance = maxIDDistance
        self.dataSources = dataSources
        self.showLocation = showLocation
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(maxIDDistance, forKey: preferenceKeys.maxIDDistance)
        aCoder.encode(dataSources, forKey: preferenceKeys.dataSources)
        aCoder.encode(showLocation, forKey: preferenceKeys.showLocation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        maxIDDistance = aDecoder.decodeInteger(forKey: preferenceKeys.maxIDDistance)
        guard let tempDataSources = aDecoder.decodeObject(forKey: preferenceKeys.dataSources) as? [String: Bool] else{
            return nil
        }
        dataSources = tempDataSources
        showLocation = aDecoder.decodeBool(forKey: preferenceKeys.showLocation)
        super.init()
    }
    
    
}
