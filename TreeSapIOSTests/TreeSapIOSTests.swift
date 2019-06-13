//
//  TreeSapIOSTests.swift
//  TreeSapIOSTests
//
//  Created by Summer2019 on 5/16/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest
import MapKit
@testable import TreeSapIOS

class TreeSapIOSTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let coordinates = CLLocationCoordinate2D(latitude: 91, longitude: 45)
        print("Latitude: \(coordinates.latitude)")
        print("Longitude: \(coordinates.longitude)")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
