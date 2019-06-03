//
//  TreeFinder.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer on 5/20/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MapKit

class TreeFinder {
    /**
     Searches for the Tree object closest to the specified location that is within the specified distance of the location. The search is conducted using the specified data sources. If no trees are found within the cutoff distance of the specified location, the function returns nil.
     - Parameters:
     - location: The location that is used in the search
     - dataSources: An array of DataSource objects that contain the Tree objects that are searched through
     - cutoffDistance: The cutoff distance for the search
     */
    class func findTreeByLocation(location: CLLocationCoordinate2D, dataSources: [DataSource], cutoffDistance: Double) -> Tree? {
        var closestTree: Tree?
        var closestDistance: CLLocationDistance?
        for dataSource in dataSources {
            for tree in dataSource.getTreeList() {
                let treeDistance = distanceBetween(from: location, to: tree.location)
                if treeDistance <= cutoffDistance {
                    if closestTree == nil || treeDistance < closestDistance! {
                        closestTree = tree
                        closestDistance = treeDistance
                    }
                }
            }
        }
        return closestTree
    }
    
    /**
     Searches for the Tree object closest to the specified location that is within the specified distance of the location. The search is conducted using the specified data sources. If no trees are found within the cutoff distance of the specified location, the function returns nil.
     - Parameters:
     - latitude: the latitude of the location used in the search
     - longitude: the longitude of the location used in the search
     - dataSources: An array of DataSource objects that contain the Tree objects that are searched through
     - cutoffDistance: the cutoff distance for the search
     */
    class func findTreeByLocation(latitude: Double, longitude: Double, dataSources: [DataSource], cutoffDistance: Double) -> Tree?{
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return TreeFinder.findTreeByLocation(location: locationCoordinates, dataSources: dataSources, cutoffDistance: cutoffDistance)
    }

    class func distanceBetween(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let locationFrom = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let locationTo = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return locationFrom.distance(from: locationTo)
    }

    /**
     Searches for a Tree object in the DataSource with the given name (.dataSourceName) using the ID of the Tree (.id)

     - Parameters:
     - treeId: the ID of the tree that is to be searched for
     - dataSourceName: the name of the DataSource object that contains the Tree object, if it exists
     - dataSources: an array of Datasources which includes the given DataSource object, if it exists
     */
    class func findTreeByID(treeID: Int, dataSourceName: String, dataSources: [DataSource]) -> Tree? {
        // Find the DataSource in which the tree is to be found based on the name
        var dataSource: DataSource!
        var isFound: Bool = false
        for source in dataSources {
            if source.dataSourceName == dataSourceName {
                dataSource = source
                isFound = true
            }
        }
        if !isFound {
            return nil
        }

        // Find the tree in the data source based on the ID of the tree
        for tree in dataSource.trees {
            if tree.id == treeID {
                return tree
            }
        }
        return nil
    }
}
