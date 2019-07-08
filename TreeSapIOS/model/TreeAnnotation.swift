//
//  TreeAnnotation.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer in Summer 2019.
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
        let redOffset = CGFloat(Float.random(in: -0.075 ... 0.075))
        let greenOffset = CGFloat(Float.random(in: -0.075 ... 0.075))
        let blueOffset = CGFloat(Float.random(in: -0.075 ... 0.075))
        var baseColor: UIColor?
        if tree.userID == AccountManager.getUserID(), AccountManager.getUserID() != nil {
            baseColor = UIColor(named: "myTree")
        } else {
            baseColor = UIColor(named: "treesapGreen")
        }
        return UIColor(red: baseColor!.rgba.0 + redOffset, green: baseColor!.rgba.1 + greenOffset, blue: baseColor!.rgba.2 + blueOffset, alpha: 1.0)
    }

    init(tree: Tree) {
        self.tree = tree
        coordinate = tree.location
        title = tree.commonName
        subtitle = tree.scientificName
        super.init()
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}
