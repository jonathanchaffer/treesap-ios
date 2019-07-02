//
//  TreeAnnotationTests.swift
//  TreeSapIOSTests
//
//  Created by Research on 6/11/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import MapKit
@testable import TreeSapIOS
import XCTest

class TreeAnnotationTests: XCTestCase {
    func testTreeAnnotation() {
        let treeCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 72.3, longitude: -84.785)
        let tree: Tree = Tree(id: 81, commonName: "Name of Tree", scientificName: "Scientific Name of Tree", location: treeCoordinates, native: true, userID: "abc")
        let treeAnnotation: TreeAnnotation = TreeAnnotation(tree: tree)

        XCTAssertEqual(treeAnnotation.title, tree.commonName)
        XCTAssertEqual(treeAnnotation.subtitle, tree.scientificName)
        XCTAssertEqual(treeAnnotation.coordinate.latitude, tree.location.latitude)
        XCTAssertEqual(treeAnnotation.coordinate.longitude, tree.location.longitude)

        let treeAnnotationTree: Tree = treeAnnotation.tree
        XCTAssertEqual(treeAnnotationTree.id, tree.id)
        XCTAssertEqual(treeAnnotationTree.commonName, tree.commonName)
        XCTAssertEqual(treeAnnotationTree.scientificName, tree.scientificName)
        XCTAssertEqual(treeAnnotationTree.location.latitude, tree.location.latitude)
        XCTAssertEqual(treeAnnotationTree.location.longitude, tree.location.longitude)
    }
}
