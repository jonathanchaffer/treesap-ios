//
//  TreeTests.swift
//  TreeSapIOSTests
//
//  Created by Research on 6/11/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import MapKit
@testable import TreeSapIOS
import XCTest

class TreeTests: XCTestCase {
    func testTree() {
        let treeCoordinates = CLLocationCoordinate2D(latitude: 75.3698153, longitude: -91.0243655)
        let tree: Tree = Tree(id: 29, commonName: "Tree name", scientificName: "Scientific name", location: treeCoordinates, native: true, userID: "abc")
        XCTAssertEqual(tree.id, 29)
        XCTAssertEqual(tree.commonName, "Tree name")
        XCTAssertEqual(tree.scientificName, "Scientific name")
        XCTAssertEqual(tree.location.latitude, treeCoordinates.latitude)
        XCTAssertEqual(tree.location.longitude, treeCoordinates.longitude)
    }
}
