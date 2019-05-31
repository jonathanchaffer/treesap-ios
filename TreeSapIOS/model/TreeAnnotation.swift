//
//  TreeAnnotation.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/22/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MapKit

class TreeAnnotation: NSObject, MKAnnotation {
    let tree: Tree
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(tree: Tree) {
        self.tree = tree
        coordinate = tree.location
        title = tree.commonName
        subtitle = tree.scientificName
        super.init()
    }
}
