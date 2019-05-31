//
//  TreeFinderTests.swift
//  TreeSapIOSTests
//
//  Created by CS Student on 5/31/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest
@testable import TreeSapIOS
import MapKit

class TreeFinderTests: XCTestCase {
    let distanceBetweenMarginOfError: Double = 0.00001
    
    /**
     Uses the distance formula to calculate the distance between to points
     
     - Parameters:
     - point1: A CLLocationCoordinate2D that gives the location of the first point
     - point2: A CLLocationCoordinate2D that gives the location of the second point
     
     - Returns: A double that gives the distance between the two points
     */
    func distanceBetweenPoints(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double{
        let latitudeDistance: Double = point1.latitude - point2.latitude
        let longitudeDistance: Double = point1.longitude - point2.longitude
        return ((latitudeDistance * latitudeDistance) + (longitudeDistance * longitudeDistance)).squareRoot()
    }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDistanceBetweenWithCases(){
        //latitude value sare in the range [-90, 90] and longitude values are in the range [-180, 180]
        let distanceBetweenTestCases = [(38.1358762, 68.4387746, 38.1358762, 68.4387746), (-90, -270, 90, 270)]
        
        for testCase in distanceBetweenTestCases{
            let point1 = CLLocationCoordinate2D(latitude: testCase.0, longitude: testCase.1)
            let point2 = CLLocationCoordinate2D(latitude: testCase.2, longitude: testCase.3)
            
            let testDistance: Double = distanceBetweenPoints(point1: point1, point2: point2)
            let actualDistance: Double = TreeFinder.distanceBetween(from: point1, to: point2)
            
            XCTAssertEqual(actualDistance, testDistance, accuracy: distanceBetweenMarginOfError, "Expected the calculated distance between points to be close to the expected value.")
        }
    }
    
    func testDistanceBetweenWithRandomGenerator(){
        let numCases = 1000
        
        for _ in 0 ..< numCases{
            let point1 = CLLocationCoordinate2D(latitude: Double.random(in: -90 ... 90), longitude: Double.random(in: -180 ... 180))
            let point2 = CLLocationCoordinate2D(latitude: Double.random(in: -90 ... 90), longitude: Double.random(in: -180 ... 180))
            
            let testDistance: Double = distanceBetweenPoints(point1: point1, point2: point2)
            let actualDistance: Double = TreeFinder.distanceBetween(from: point1, to: point2)
            
            XCTAssertEqual(actualDistance, testDistance, accuracy: distanceBetweenMarginOfError, "Expected the calculated distance between points to be close to the expected value.")
        }
    }

}
