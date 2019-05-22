//
//  TreePointAnnotationView.swift
//  TreeSapIOS
//
//  Created by Summer2019 on 5/22/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import Foundation
import MapKit

class TreePointAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = true
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let redOffset = CGFloat(Float.random(in: -0.1...0.1))
            let greenOffset = CGFloat(Float.random(in: -0.1...0.1))
            let blueOffset = CGFloat(Float.random(in: -0.1...0.1))
            tintColor = UIColor(red: 0.4470588235 + redOffset, green: 0.7411764706 + greenOffset, blue: 0.3529411765 + blueOffset, alpha: 1.0)
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = true // 1
        self.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = true // 1
        self.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
}
