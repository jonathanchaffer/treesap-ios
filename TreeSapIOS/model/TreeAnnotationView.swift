//
//  TreeAnnotationView.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/22/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MapKit

class TreeAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = true
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let redOffset = CGFloat(Float.random(in: -0.1...0.1))
            let greenOffset = CGFloat(Float.random(in: -0.1...0.1))
            let blueOffset = CGFloat(Float.random(in: -0.1...0.1))
            markerTintColor = UIColor(red: 0.4470588235 + redOffset, green: 0.7411764706 + greenOffset, blue: 0.3529411765 + blueOffset, alpha: 1.0)
            glyphImage = UIImage(named: "tree")
            titleVisibility = .hidden
            subtitleVisibility = .hidden
            //clusteringIdentifier = nil
            displayPriority = .required
        }
    }
}
