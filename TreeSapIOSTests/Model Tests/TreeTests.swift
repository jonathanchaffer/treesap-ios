//
//  TreeTests.swift
//  TreeSapIOSTests
//
//  Created by Research on 6/11/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest
import MapKit
@testable import TreeSapIOS

class TreeTests: XCTestCase {

    func testTree(){
        let treeCoordinates = CLLocationCoordinate2D(latitude: 75.3698153, longitude: -91.0243655)
        let tree: Tree = Tree(id: 29, commonName: "Tree name", scientificName: "Scientific name", location: treeCoordinates, dbh: 32.52, native: true, userID: "abc")
        XCTAssertEqual(tree.id, 29)
        XCTAssertEqual(tree.commonName, "Tree name")
        XCTAssertEqual(tree.scientificName, "Scientific name")
        XCTAssertEqual(tree.location.latitude, treeCoordinates.latitude)
        XCTAssertEqual(tree.location.longitude, treeCoordinates.longitude)
        XCTAssertEqual(tree.dbh, 32.52)
    }
}
