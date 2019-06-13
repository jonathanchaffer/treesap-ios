//
//  TreeFinder.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MapKit

class TreeFinder {
    /**
     Searches for the Tree object closest to the specified location within the specified cutoff distance from the location.
     - Parameters:
        - location: The location used in the search.
        - dataSources: An array of DataSources to be searched.
        - cutoffDistance: The cutoff distance for the search.
     - Returns: The found Tree, or nil if none was found.
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
     Searches for the Tree object closest to the specified location within the specified cutoff distance from the location.
     - Parameters:
         - latitude: The latitude of the location used in the search.
         - longitude: The longitude of the location used in the search.
         - dataSources: An array of DataSources to be searched.
         - cutoffDistance: The cutoff distance for the search.
     - Returns: The found Tree, or nil if none was found.
     */
    class func findTreeByLocation(latitude: Double, longitude: Double, dataSources: [DataSource], cutoffDistance: Double) -> Tree? {
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return TreeFinder.findTreeByLocation(location: locationCoordinates, dataSources: dataSources, cutoffDistance: cutoffDistance)
    }

    class func distanceBetween(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let locationFrom = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let locationTo = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return locationFrom.distance(from: locationTo)
    }
}
