//
//  TreeAnnotation.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MapKit

class TreeAnnotation: NSObject, MKAnnotation {
    let tree: Tree
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    var markerTintColor: UIColor {
        let redOffset = CGFloat(Float.random(in: -0.1 ... 0.1))
        let greenOffset = CGFloat(Float.random(in: -0.1 ... 0.1))
        let blueOffset = CGFloat(Float.random(in: -0.1 ... 0.1))
        if tree.userID == AccountManager.getUserID() {
            return UIColor(red: 46/255 + redOffset, green: 129/255 + greenOffset, blue: 219/255 + blueOffset, alpha: 1.0)
        } else {
            return UIColor(red: 0.447 + redOffset, green: 0.741 + greenOffset, blue: 0.353 + blueOffset, alpha: 1.0)
        }
    }
    
    init(tree: Tree) {
        self.tree = tree
        coordinate = tree.location
        title = tree.commonName
        subtitle = tree.scientificName
        super.init()
    }
}
