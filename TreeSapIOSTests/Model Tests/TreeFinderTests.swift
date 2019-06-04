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
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func setUp() {
        for dataSource in appDelegate.dataSources{
            print("Did retrieve online data: \(dataSource.retrieveOnlineData())")
        }
    }
    
    /**
     For each element in the array entered, tests that function findTreeByLocation in the TreeFinder class finds a tree with the specified name, longitude, and latitude when searching through the specified data sources using the specified cutoff distance. If no name is provided, the found tree should lack a name.
     - Parameters:
     - trees: An array containing a tuple with the common name, latitude, and longitude, respectively, of each tree that is to be searched for. The common name is optional
     - dataSources: An array of the dataSources that the findTreeByLocation method searches through
     - cutoffDistance: The cutoff distance that is to be used in each search. If nil, this defaults to 1
     */
    func findsCorrectTreesByLocation(trees: [(String?, Double, Double)], dataSources: [DataSource], cutoffDistance: Double?){
        for tree in trees{
            //The findTreeByLocation function uses the specified coordinates to serach for a tree
            var foundTree: Tree?
            if(cutoffDistance == nil){
                foundTree = TreeFinder.findTreeByLocation(latitude: tree.1, longitude: tree.2, dataSources: dataSources, cutoffDistance: 1)
            }
            else{
                foundTree = TreeFinder.findTreeByLocation(latitude: tree.1, longitude: tree.2, dataSources: dataSources, cutoffDistance: cutoffDistance!)
            }
            
            //Checks that a tree was found
            if(foundTree == nil){
                let treeName: String = tree.0 ?? "nil"
                XCTFail("A tree should have been found with the common name \(treeName) and the coordinates \(tree.1), \(tree.2), but none was.")
            }
            //Check that the found tree has the specified name and coordinates
            else{
                let treeName: String =  foundTree!.commonName ?? "nil"
                XCTAssertEqual(treeName, tree.0, "Found tree has the name " + treeName + " instead of \(tree.0!).")
                let location: CLLocationCoordinate2D = foundTree!.location
                XCTAssertEqual(location.latitude, tree.1, "Found tree has a latitude of \(location.latitude) instead of \(tree.1).")
                XCTAssertEqual(location.longitude, tree.2, "Found tree has a longitude of \(location.longitude) instead of \(tree.2).")
            }
        }
    }
    
    /**
     For each element in the array entered, tests that the function findTreeByLocation in the TreeFinder class finds no tree when using the specified coordinates, data sources, and cutoff distance to search.
     - Parameters:
     - latitude: The latitude used in the search
     - longitude: The longitude used in the search
     - cutoffDistance: The cutoff distance that is to be used in each search. If nil, this defaults to 1
     */
    func findsNoTreesByLocation(coordinates: [(Double, Double)], dataSources: [DataSource], cutoffDistance: Double?){
        for location in coordinates{
            let usedCutoffdistance: Double = cutoffDistance ?? 1
            let foundTree: Tree? = TreeFinder.findTreeByLocation(latitude: location.0, longitude: location.1, dataSources: dataSources, cutoffDistance: usedCutoffdistance)
            
            if(foundTree != nil){
                let treeName: String = foundTree!.commonName ?? "nil"
                XCTFail("No tree should have been found, but a tree with the common name \(treeName) and the coordinates \(foundTree!.location.latitude), \(foundTree!.location.longitude) was found.")
            }
        }

    }

    /**
     Returns an array of Data Source objects with the specified names. It is assumed that none of the data sources have the same name.
     - Parameter dataSourceNames: An array of strings with the names of the DataSource Objects that are to be returned
     - Returns: An array of DataSource objects with names matching any of specified names
     */
    func returnListedDataSources(dataSourceNames: [String]) -> [DataSource]{
        var dataSourceList: [DataSource] = [DataSource]()
        for dataSource in appDelegate.dataSources{
            for name in dataSourceNames{
                if(dataSource.dataSourceName == name){
                    dataSourceList.append(dataSource)
                    break
                }
            }
        }
        
        return dataSourceList
    }
    
    func testCityOfHollandUsingTestCases(){
        let dataSourceList: [DataSource] = returnListedDataSources(dataSourceNames: ["City of Holland Tree Inventory"])
        findsCorrectTreesByLocation(trees: cityOfHollandFoundCases, dataSources: dataSourceList, cutoffDistance: nil)
    }
    
    func testCityOfHollandNoneFound(){
        let dataSourceList: [DataSource] = returnListedDataSources(dataSourceNames: ["City of Holland Tree Inventory"])
        findsNoTreesByLocation(coordinates: cityOfHollandNotFoundCases, dataSources: dataSourceList, cutoffDistance: nil)
    }
    
    func testCityOfHollandAllTrees(){
        let dataSourceList: [DataSource] = returnListedDataSources(dataSourceNames: ["City of Holland Tree Inventory"])
        var treeList =  [(String?, Double, Double)]()
        for tree in dataSourceList[0].trees{
            var nextElement: (String?, Double, Double)
            nextElement.0 = tree.commonName
            nextElement.1 = tree.location.latitude
            nextElement.2 = tree.location.longitude
            treeList.append(nextElement)
        }
        
        findsCorrectTreesByLocation(trees: treeList, dataSources: dataSourceList, cutoffDistance: nil)
    }
    
    func testHopeCollegeDataSource(){
    }
    
    func testITreeDataSource(){
    }
    
    func testBenefitsDataSource(){
    }

    //MARK: Tests Cases
    //Cases that include trees in the data set. Problems with the name formatter may make these test cases inaccurate.
    let cityOfHollandFoundCases: [(String?, Double, Double)] = [("Sugar Maple", 42.78836770600, -86.10785853600), ("Black Maple", 42.78699045400,-86.10858494600), ("European Beech", 42.78806326200,-86.10811641200), ("Red Maple", 42.79063704400,-86.05987365400), ("Silver Maple", 42.79055218500,-86.05074439300), ("Field Maple", 42.78327084200,-86.06846538400), ("Callery Pear", 42.76959446700,-86.12547271900)]
    //Cases that include trees not in the data set. These a inteded for use using the default cutoff distance of 1. Increasing the cutoff distance may affect the results.
    let cityOfHollandNotFoundCases: [(Double, Double)] = [(-42.78836770600, 86.10785853600), (43.148359212, 49.928309280), (-45.3154244752, -45.14254857), (18.15739996, 27.425369824), (-90, -180), (-90, 180), (90, -180), (90, 180), (52.354971, 78.3246986), (42.12485348,  -86.9841262)]
    
    // This function does not work
    //    /**
    //     Uses the distance formula to calculate the distance between to points
    //
    //     - Parameters:
    //     - point1: A CLLocationCoordinate2D that gives the location of the first point
    //     - point2: A CLLocationCoordinate2D that gives the location of the second point
    //
    //     - Returns: A double that gives the distance between the two points
    //     */
    //    func distanceBetweenPoints(point1: CLLocationCoordinate2D, point2: CLLocationCoordinate2D) -> Double{
    //        let latitudeDistance: Double = point1.latitude - point2.latitude
    //        let longitudeDistance: Double = point1.longitude - point2.longitude
    //        return ((latitudeDistance * latitudeDistance) + (longitudeDistance * longitudeDistance)).squareRoot()
    //    }
    
    //    func testDistanceBetweenWithCases(){
    //        //latitude value sare in the range [-90, 90] and longitude values are in the range [-180, 180]
    //        let distanceBetweenTestCases = [(38.1358762, 68.4387746, 38.1358762, 68.4387746), (-90, -270, 90, 270)]
    //
    //        for testCase in distanceBetweenTestCases{
    //            let point1 = CLLocationCoordinate2D(latitude: testCase.0, longitude: testCase.1)
    //            let point2 = CLLocationCoordinate2D(latitude: testCase.2, longitude: testCase.3)
    //
    //            let testDistance: Double = distanceBetweenPoints(point1: point1, point2: point2)
    //            let actualDistance: Double = TreeFinder.distanceBetween(from: point1, to: point2)
    //
    //            XCTAssertEqual(actualDistance, testDistance, accuracy: distanceBetweenMarginOfError, "Expected the calculated distance between points to be close to the expected value.")
    //        }
    //    }
    
    //    func testDistanceBetweenWithRandomGenerator(){
    //        let numCases = 1000
    //
    //        for _ in 0 ..< numCases{
    //            let point1 = CLLocationCoordinate2D(latitude: Double.random(in: -90 ... 90), longitude: Double.random(in: -180 ... 180))
    //            let point2 = CLLocationCoordinate2D(latitude: Double.random(in: -90 ... 90), longitude: Double.random(in: -180 ... 180))
    //
    //            let testDistance: Double = distanceBetweenPoints(point1: point1, point2: point2)
    //            let actualDistance: Double = TreeFinder.distanceBetween(from: point1, to: point2)
    //
    //            XCTAssertEqual(actualDistance, testDistance, accuracy: distanceBetweenMarginOfError, "Expected the calculated distance between points to be close to the expected value.")
    //        }
    //    }
}
