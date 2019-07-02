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
     Searches for the Tree objects closest to the specified location within the specified cutoff distance from the location.
     - Parameters:
        - location: The location used in the search.
        - dataSources: An array of DataSources to be searched.
        - cutoffDistance: The cutoff distance for the search.
        - maxNumTrees: The maximum number of trees to return.
     - Returns: An array containing the trees closest to the location, ordered from closest to furthest.
     */
    class func findTreesByLocation(location: CLLocationCoordinate2D, dataSources: [DataSource], cutoffDistance: Double, maxNumTrees: Int) -> [Tree] {
        var nearbyTrees = [Tree]()
        for _ in 0 ..< maxNumTrees {
            var closestTree: Tree?
            var closestDistance: CLLocationDistance?
            for dataSource in dataSources {
                for tree in dataSource.getTreeList() {
                    let treeDistance = distanceBetween(from: location, to: tree.location)
                    if treeDistance <= cutoffDistance {
                        if closestTree == nil || treeDistance < closestDistance! {
                            if !nearbyTrees.contains(tree) {
                                closestTree = tree
                                closestDistance = treeDistance
                            }
                        }
                    }
                }
            }
            if closestTree != nil {
                nearbyTrees.append(closestTree!)
            } else {
                break
            }
        }
        return nearbyTrees
    }

    class func findTreeByLocation(location: CLLocationCoordinate2D, dataSources: [DataSource], cutoffDistance: Double) -> Tree? {
        let nearestTreeArray = findTreesByLocation(location: location, dataSources: dataSources, cutoffDistance: cutoffDistance, maxNumTrees: 1)
        if !nearestTreeArray.isEmpty {
            return nearestTreeArray.first
        }
        return nil
    }

    class func findTreeByLocation(latitude: Double, longitude: Double, dataSources: [DataSource], cutoffDistance: Double) -> Tree? {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return findTreeByLocation(location: coordinate, dataSources: dataSources, cutoffDistance: cutoffDistance)
    }

    class func distanceBetween(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let locationFrom = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let locationTo = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return locationFrom.distance(from: locationTo)
    }
}
