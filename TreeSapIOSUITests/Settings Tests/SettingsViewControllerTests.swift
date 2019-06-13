//
//  SettingsViewControllerTests.swift
//  TreeSapIOSUITests
//
//  Created by Research on 6/11/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest
import UIKit

class SettingsViewControllerTests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = UIDeviceOrientation.portrait
        
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        
        let settingsButton = app.navigationBars["Home"].children(matching: .button).element(boundBy: 1)
        let exists = NSPredicate(format: "exists == 1")
        let settingsExpectation = expectation(for: exists, evaluatedWith: settingsButton, handler: nil)
        wait(for: [settingsExpectation], timeout: 8)
        settingsButton.tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMaxIdentificationDistance(){
        let tablesQuery = app.tables
        let textField = tablesQuery.cells.containing(.staticText, identifier: "Max identification distance").children(matching: .textField).element
        
        //Tests that the app accepts user input for the max identification distance and changes the value shown in the text field accordingly
        textField.tap()
        tablesQuery.buttons["Clear text"].tap()
        app.keys["2"].tap()
        app.keys["3"].tap()
        app.keys["."].tap()
        app.keys["4"].tap()
        app.buttons["Done"].tap()
        var text = textField.value as! String
        XCTAssertEqual(text, "23.4", "The max identification distance text field was not changed to \"23.4\"")
        
        //Test that characters other than numbers and "." cannot be entered into the text field
        textField.tap()
        app.keys["more"].tap()
        app.keys["c"].tap()
        app.buttons["shift"].tap()
        app.keys["G"].tap()
        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["@"].tap()
        app.keys[","].tap()
        app.keys["?"].tap()
        app.keys["-"].tap()
        app.buttons["shift"].tap()
        app.keys["="].tap()
        text = textField.value as! String
        XCTAssertEqual(text, "23.4", "The max identification distance text field accepted characters other than numbers and \".\"")
        
        //Test that the app responds correctly when the text field is left empty
        textField.tap()
        tablesQuery.buttons["Clear text"].tap()
        tablesQuery.children(matching: .other)["DATA SETTINGS"].children(matching: .other)["DATA SETTINGS"].tap()
        app.alerts["Invalid number"].buttons["OK"].tap()
        text = textField.value as! String
        XCTAssertEqual(text, "100.0", "The max identification distance text field was not reset to the default max identification distance of \"100.0\".")
    }
    
    func testPressesDataSources(){
        let tablesQuery = app.tables
        tablesQuery.staticTexts["Active data sources"].tap()
        
        let cityOfHollandButton = tablesQuery.staticTexts["City of Holland Tree Inventory"]
        let hopeCollegeButton = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Hope College i-Tree Data"]/*[[".cells.staticTexts[\"Hope College i-Tree Data\"]",".staticTexts[\"Hope College i-Tree Data\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let iTreeButton = tablesQuery.staticTexts["Hope College Trees"]
        let treeBenefitButton = tablesQuery.staticTexts["Tree Benefit Data"]
        
        cityOfHollandButton.tap()
        hopeCollegeButton.tap()
        iTreeButton.tap()
        treeBenefitButton.tap()
        
        cityOfHollandButton.tap()
        hopeCollegeButton.tap()
        iTreeButton.tap()
        treeBenefitButton.tap()
        
        app.navigationBars["Active Data Sources"].buttons["Settings"].tap()
    }
    
    func testMoreInformation(){
        let tablesQuery = app.tables
        
        tablesQuery.staticTexts["More information"].tap()
        app.navigationBars["More Information"].buttons["Settings"].tap()
    }
    
    func testShowUserLocation(){
        let toggle = app.switches["Show Location Switch"]
        toggle.tap()
        toggle.tap()
    }
}
