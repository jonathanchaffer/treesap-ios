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
     Searches for a Tree object by location.
     */
    class func findTreeByLocation(location: CLLocationCoordinate2D, dataSets: [[Tree]], cutoffDistance: Double) -> Tree? {
        var closestTree: Tree? = nil
        var closestDistance: CLLocationDistance? = nil
        for set in dataSets {
            for tree in set {
                let treeDistance = distanceBetween(from: location, to: tree.getLocation())
                if (treeDistance <= cutoffDistance) {
                    if (closestTree == nil || treeDistance < closestDistance!) {
                        closestTree = tree
                        closestDistance = treeDistance
                    }
                }
            }
        }
        return closestTree
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
    class func findTreeByID(treeID: Int, dataSourceName: String, dataSources: [DataSource]) -> Tree?{
        //Find the DataSource in which the tree is to be found based on the name
        var dataSource: DataSource!
        var isFound: Bool = false
        for source in dataSources{
            if(source.dataSourceName == dataSourceName){
                dataSource = source
                isFound = true
            }
        }
        if(!isFound){
            return nil
        }
        
        //Find the tree in the data source based on the ID of the tree
        for tree in dataSource.trees{
            if(tree.id == treeID){
                return tree
            }
        }
        return nil
    }
}
