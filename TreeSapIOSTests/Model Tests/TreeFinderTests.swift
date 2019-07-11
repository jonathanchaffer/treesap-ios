//
//  TreeFinderTests.swift
//  TreeSapIOSTests
//
//  Created by Josiah Brett on 5/31/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import MapKit
@testable import TreeSapIOS
import XCTest

class TreeFinderTests: XCTestCase {
    let distanceBetweenMarginOfError: Double = 0.00001

    // This function does not adequately set up the app by setting all of the data sources to be active
    override func setUp() {
        for dataSource in DataManager.dataSources {
            dataSource.importOnlineTreeData()
        }
    }

    /**
     For each element in the array entered, tests that function findTreeByLocation in the TreeFinder class finds a tree with the specified name, longitude, and latitude when searching through the specified data sources using the specified cutoff distance. If no name is provided, the found tree should lack a name.
     - Parameters:
     - trees: An array containing a tuple with the common name, latitude, and longitude, respectively, of each tree that is to be searched for. The common name is optional
     - dataSources: An array of the dataSources that the findTreeByLocation function searches through
     - cutoffDistance: The cutoff distance that is to be used in each search. If nil, this defaults to 1
     */
    func findsCorrectTreesByLocation(trees: [(String?, Double, Double)], dataSources: [DataSource], cutoffDistance: Double?) {
        for tree in trees {
            // The findTreeByLocation function uses the specified coordinates to serach for a tree
            var foundTree: Tree?
            if cutoffDistance == nil {
                foundTree = TreeFinder.findTreeByLocation(latitude: tree.1, longitude: tree.2, dataSources: dataSources, cutoffDistance: 1)
            } else {
                foundTree = TreeFinder.findTreeByLocation(latitude: tree.1, longitude: tree.2, dataSources: dataSources, cutoffDistance: cutoffDistance!)
            }

            // Checks that a tree was found
            if foundTree == nil {
                let treeName: String = tree.0 ?? "nil"
                XCTFail("A tree should have been found with the common name \(treeName) and the coordinates \(tree.1), \(tree.2), but none was.")
            }
            // Check that the found tree has the specified name and coordinates
            else {
                let treeName: String = foundTree!.commonName ?? "nil"
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
    func findsNoTreesByLocation(coordinates: [(Double, Double)], dataSources: [DataSource], cutoffDistance: Double?) {
        for location in coordinates {
            let usedCutoffdistance: Double = cutoffDistance ?? 1
            let foundTree: Tree? = TreeFinder.findTreeByLocation(latitude: location.0, longitude: location.1, dataSources: dataSources, cutoffDistance: usedCutoffdistance)

            if foundTree != nil {
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
    func returnListedDataSources(dataSourceNames: [String]) -> [DataSource] {
        var dataSourceList: [DataSource] = [DataSource]()
        for dataSource in DataManager.dataSources {
            for name in dataSourceNames {
                if dataSource.dataSourceName == name {
                    dataSourceList.append(dataSource)
                    break
                }
            }
        }

        return dataSourceList
    }

    func testNoneFound() {
        let dataSourceList: [DataSource] = returnListedDataSources(dataSourceNames: ["City of Holland Tree Inventory"])
        findsNoTreesByLocation(coordinates: notFoundCases, dataSources: dataSourceList, cutoffDistance: nil)
    }

    func testCityOfHollandUsingTestCases() {
        let dataSourceList: [DataSource] = returnListedDataSources(dataSourceNames: ["City of Holland Tree Inventory"])
        findsCorrectTreesByLocation(trees: cityOfHollandFoundCases, dataSources: dataSourceList, cutoffDistance: nil)
    }

    func testCityOfHollandAllTrees() {
        let dataSourceList: [DataSource] = returnListedDataSources(dataSourceNames: ["City of Holland Tree Inventory"])
        var treeList = [(String?, Double, Double)]()
        for tree in dataSourceList[0].trees {
            var nextElement: (String?, Double, Double)
            nextElement.0 = tree.commonName
            nextElement.1 = tree.location.latitude
            nextElement.2 = tree.location.longitude
            treeList.append(nextElement)
        }

        findsCorrectTreesByLocation(trees: treeList, dataSources: dataSourceList, cutoffDistance: nil)
    }

    func testHopeCollegeUsingTestCases() {
        let dataSourceList: [DataSource] = returnListedDataSources(dataSourceNames: ["Hope College Trees"])
        findsCorrectTreesByLocation(trees: hopeCollegeFoundCases, dataSources: dataSourceList, cutoffDistance: nil)
    }

    func testHopeCollegeAllTrees() {
        let dataSourceList: [DataSource] = returnListedDataSources(dataSourceNames: ["Hope College Trees"])
        var treeList = [(String?, Double, Double)]()
        for tree in dataSourceList[0].trees {
            var nextElement: (String?, Double, Double)
            nextElement.0 = tree.commonName
            nextElement.1 = tree.location.latitude
            nextElement.2 = tree.location.longitude
            treeList.append(nextElement)
        }

        findsCorrectTreesByLocation(trees: treeList, dataSources: dataSourceList, cutoffDistance: nil)
    }

    func testITreeUsingTestCases() {
        let dataSourceList: [DataSource] = returnListedDataSources(dataSourceNames: ["Hope College i-Tree Data"])
        findsCorrectTreesByLocation(trees: iTreeFoundCases, dataSources: dataSourceList, cutoffDistance: nil)
    }

    func testITreeAllTrees() {
        let dataSourceList: [DataSource] = returnListedDataSources(dataSourceNames: ["Hope College i-Tree Data"])
        var treeList = [(String?, Double, Double)]()
        for tree in dataSourceList[0].trees {
            var nextElement: (String?, Double, Double)
            nextElement.0 = tree.commonName
            nextElement.1 = tree.location.latitude
            nextElement.2 = tree.location.longitude
            treeList.append(nextElement)
        }

        findsCorrectTreesByLocation(trees: treeList, dataSources: dataSourceList, cutoffDistance: nil)
    }

    func testTreeBenefitsUsingTestCases() {
        let dataSourceList: [DataSource] = returnListedDataSources(dataSourceNames: ["Tree Benefit Data"])
        findsCorrectTreesByLocation(trees: treeBenefitsFoundCases, dataSources: dataSourceList, cutoffDistance: nil)
    }

    func testTreeBenefitsAllTrees() {
        let dataSourceList: [DataSource] = returnListedDataSources(dataSourceNames: ["Tree Benefit Data"])
        var treeList = [(String?, Double, Double)]()
        for tree in dataSourceList[0].trees {
            var nextElement: (String?, Double, Double)
            nextElement.0 = tree.commonName
            nextElement.1 = tree.location.latitude
            nextElement.2 = tree.location.longitude
            treeList.append(nextElement)
        }
    }

    // MARK: Tests Cases

    /// Test case that includes trees not to be found in any of the data bases.
    let notFoundCases: [(Double, Double)] = [(-42.78836770600, 86.10785853600), (43.148359212, 49.928309280), (-45.3154244752, -45.14254857), (18.15739996, 27.425369824), (-90, -180), (-90, 180), (90, -180), (90, 180), (52.354971, 78.3246986), (42.12485348, -86.9841262)]

    // City of Holland Test Cases
    /// Cases that include trees in the Holland data set. Problems with the name formatter may make these test cases inaccurate.
    let cityOfHollandFoundCases: [(String?, Double, Double)] = [("Sugar Maple", 42.78836770600, -86.10785853600), ("Black Maple", 42.78699045400, -86.10858494600), ("European Beech", 42.78806326200, -86.10811641200), ("Red Maple", 42.79063704400, -86.05987365400), ("Silver Maple", 42.79055218500, -86.05074439300), ("Field Maple", 42.78327084200, -86.06846538400), ("Callery Pear", 42.76959446700, -86.12547271900)]

    // Hope College Test Cases
    /// Cases that include trees in the Hope College data set.
    let hopeCollegeFoundCases: [(String?, Double, Double)] = [("Red Mulberry", 42.78870773, -86.10109711), ("Sugar Maple", 42.78830719, -86.103302), ("Canadian Hemlock", 42.78782654, -86.10236359), ("Sugar Maple", 42.78755951, -86.10410309), ("Japanese Flowering Cherry", 42.78710938, -86.1034317), ("Sugar Maple", 42.78681183, -86.10302734), ("River Birch", 42.7869339, -86.1015625), ("River Birch", 42.78710175, -86.10154724), ("Honeylocust", 42.78752136, -86.10177612)]

    // i-Tree Test Cases
    /// Cases that include trees in the i-Tree data set.
    let iTreeFoundCases: [(String?, Double, Double)] = [("Red Mulberry", 42.78870773, -86.10109711), ("Japanese Flower Crabapple", 42.78820038, -86.10391998), ("Sugar Maple", 42.7881546, -86.10327911), ("Serviceberry", 42.78822327, -86.10135651), ("Norway Maple", 42.78820419, -86.10121918), ("Japanese Flower Crabapple", 42.78779221, -86.10171509), ("Eastern White Pine", 42.78776932, -86.10231018), ("Eastern Red Cedar", 42.78752899, -86.10355377), ("Eastern White Pine", 42.7871933, -86.10287476), ("Sugar Maple", 42.78682327, -86.10211182), ("Honeylocust", 42.78752136, -86.10177612)]

    // Tree Benefit Data Test Cases
    /// Cases that include trees in the Tree Benefits data set
    let treeBenefitsFoundCases: [(String?, Double, Double)] = [("American Basswood", 42.77405533, -86.10725963), ("American Sycamore", 42.7909676, -86.05525776), ("American Sycamore", 42.79083185, -86.05524837), ("Japanese Flowering Cherry", 42.77437772, -86.10899429), ("Littleleaf Linden", 42.78815167, -86.06422697), ("Norway Maple", 42.77798861, -86.10420353), ("Red Maple", 42.77475559, -86.11658534), ("Sugar Maple", 42.78743799, -86.05207995), ("Wych Elm", 42.78756826, -86.05535508)]
}
