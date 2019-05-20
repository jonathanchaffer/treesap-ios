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
	class func findTree(location: CLLocationCoordinate2D, dataSets: [[Tree]]) -> Tree? {
		var closestTree: Tree? = nil
		var closestDistance: CLLocationDistance? = nil
		for set in dataSets {
			for tree in set {
				let treeDistance = distanceBetween(from: location, to: tree.getLocation())
				if (closestTree == nil || treeDistance < closestDistance!) {
					closestTree = tree
					closestDistance = treeDistance
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
}
