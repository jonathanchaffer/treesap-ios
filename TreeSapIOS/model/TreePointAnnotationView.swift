//
//  TreePointAnnotationView.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/22/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MapKit

// NOTE: This class is not currently used. It is meant to be a MapKit annotation view for devices with iOS 10 and older.

class TreePointAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = true
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let redOffset = CGFloat(Float.random(in: -0.1 ... 0.1))
            let greenOffset = CGFloat(Float.random(in: -0.1 ... 0.1))
            let blueOffset = CGFloat(Float.random(in: -0.1 ... 0.1))
            tintColor = UIColor(red: 0.447 + redOffset, green: 0.741 + greenOffset, blue: 0.353 + blueOffset, alpha: 1.0)
        }
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true // 1
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        canShowCallout = true // 1
        rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
}
