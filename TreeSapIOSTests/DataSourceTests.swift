//
//  DataSourceTests.swift
//  TreeSapIOSTests
//
//  Created by CS Student on 5/22/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest
@testable import TreeSapIOS
import CSVImporter

class DataSourceTests: XCTestCase {
    var hollandSource: DataSource!
    var iTreeSource: DataSource!
    var hopeSource: DataSource!
    
    override func setUp() {
        hollandSource = DataSource(internetFilename: "CoH_Tree_Inventory_6_12_18.csv", localFilename: "holland.csv", dataSourceName: "City of Holland", csvFormat: CSVFormat.holland)
        iTreeSource = DataSource(internetFilename: "iTreeExport_119_HopeTrees_7may2018.csv", localFilename: "itree.csv", dataSourceName: "iTree", csvFormat: CSVFormat.itree)
        hopeSource = DataSource(internetFilename: "dataExport_119_HopeTrees_7may2018.csv", localFilename: "hope.csv", dataSourceName: "Hope College", csvFormat: CSVFormat.hope)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testHollandSource(){
        print(readInFile(fileName: hollandSource.localFilename))
    }
    
    //based on code from https://www.seemuapps.com/read-to-and-write-from-a-text-file-in-swift
    func readInFile(fileName: String) -> String{
        
//        let documentDirectoryURL: NSURL = FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
//
//        let fileURL: URL = documentDirectoryURL.appendingPathComponent(fileName)
//
//        let fileText: String = String.init(contentsOf: fileURL)
        return ""
    }
    
    //MARK: Copied File Text
    //City of Holland test text
    let hollandTextStart: String =
    """
    OBJECTID,CommonName,Scientific,DBH,CreationDa,Creator,EditDate,Editor,GlobalID,Park,Notes,DBH2,DBH3,Native_Non,DBH4,Latitude,Longitude
    1,Sugar maple,Acer saccharum,30.29999923710,5/8/2018,A.Ebenstein_BPW,5/8/2018,A.Ebenstein_BPW,{BE11A77A-F5DA-4959-A8BA-4279B133F762},Centennial Park,,0.00000000000,0.00000000000,,0.00000000000,42.78839462500,-86.10745071800
    2,Sugar maple,Acer saccharum,11.80000019070,5/8/2018,A.Ebenstein_BPW,5/8/2018,A.Ebenstein_BPW,{9C8C98F3-E510-4727-9DE1-6845A78566BF},Centennial Park,,0.00000000000,0.00000000000,,0.00000000000,42.78839581400,-86.10753197500
    """
    let hollandTextEnd: String =
    """
    2338,Callery pear,,9.10000000000,6/12/2018,GIS_Intern_BPW,6/12/2018,GIS_Intern_BPW,{5A1D3AA3-5327-4AEB-8370-9B0CAE1F35FA},,,0.00000000000,0.00000000000,,0.00000000000,42.77262244500,-86.12687691200
    2339,Callery pear,,8.97000000000,6/12/2018,GIS_Intern_BPW,6/12/2018,GIS_Intern_BPW,{B2A42412-EA2B-4F2E-8A14-A52A7C56CEBE},,,0.00000000000,0.00000000000,,0.00000000000,42.77275949200,-86.12687466800
    2340,Callery pear,,9.92000000000,6/12/2018,GIS_Intern_BPW,6/12/2018,GIS_Intern_BPW,{B252D089-25E0-4DB3-8ABD-49C5856F84BD},,,0.00000000000,0.00000000000,,0.00000000000,42.77288035900,-86.12688797300
    """
    let hollandTextMiddle: String =
    """
    179,White oak,Quercus alba,29.94000053410,5/8/2018,A.Ebenstein_BPW,5/8/2018,A.Ebenstein_BPW,{F6396C4F-28A0-434C-9699-80A333F6FDA9},Kollen Park,,0.00000000000,0.00000000000,,0.00000000000,42.78816665900,-86.12177598400
    180,Norway Maple,Acer platanoides,19.43000030520,5/8/2018,A.Ebenstein_BPW,5/8/2018,A.Ebenstein_BPW,{DB7B9D0F-6D46-4C6A-9350-3D790254DAAF},Kollen
    """
}
