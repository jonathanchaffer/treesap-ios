//
//  DataSourceTests.swift
//  TreeSapIOSTests
//
//  Created by CS Student on 5/20/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest

class DataSourceTests: XCTestCase {
    var testDataSource: DataSource!
    
    override func setUp() {
        testDataSourceCOH = DataSource(internetFilename: "CoH_Tree_Inventory_6_12_18.csv", localFilename: "CoHTestFile", DataSourceName: "CoHTestDataSource")
        testDataSourceHope = DataSoruce(internetFilename:"dataExport_119_HopeTrees_7may2018.csv", localFilename: "HopeTestFile", DataSourceName: "HopeTestDataSource")
        testDataSourceITree = DataSource(internetFilename: "iTreeExport_119_HopeTrees_7may2018.csv", localFilename: "iTreeTestFile", DataSourceName: "iTreeTestDataSource")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func _1testRetrieveOnlineDataCOH() {
        testDataSourceCOH.retrieveOnlineData(())
    }
}
