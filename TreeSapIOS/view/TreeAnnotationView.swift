//
//  TreeAnnotationView.swift
//  TreeSapIOS
//
//  Created by Jonathan Chaffer and Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MapKit

@available(iOS 11.0, *)
class TreeAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let treeAnnotation = newValue as? TreeAnnotation else { return }
            canShowCallout = true
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = treeAnnotation.markerTintColor
            glyphImage = UIImage(named: "tree")
            titleVisibility = .hidden
            subtitleVisibility = .hidden
            displayPriority = .required
        }
    }
}
