//
//  TreeSapIOSUITests.swift
//  TreeSapIOSUITests
//
//  Created by Summer2019 on 6/3/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest
import UIKit
@testable import TreeSapIOS

class TreeSapIOSUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    override func tearDown() { }

    func testNavigation() {
        
        // Tap the button tab
        let tabBarsQuery = app.tabBars
        let button = tabBarsQuery.buttons["Button"]
        button.tap()
        
        // Tap the coordinates tab
        let coordinatesButton = tabBarsQuery.buttons["Coordinates"]
        coordinatesButton.tap()
        
        // Tap the map tab
        let mapButton = tabBarsQuery.buttons["Map"]
        mapButton.tap()
        
        // Tap the QR code tab
        let qrCodeButton = tabBarsQuery.buttons["QR Code"]
        qrCodeButton.tap()
        
        // Tap the home tab
        let homeButton = tabBarsQuery.buttons["Home"]
        homeButton.tap()
        
        // Tap the add tree button from the home screen
        let homeNavigationBar = app.navigationBars["Home"]
        homeNavigationBar.buttons["Add"].tap()
        
        // Close the add tree screen
        let cancelButton = app.navigationBars["Add Tree"].buttons["Cancel"]
        cancelButton.tap()
        button.tap()
        
        // Tap the add tree button from the button screen
        let buttonNavigationBar = app.navigationBars["Button"]
        buttonNavigationBar.buttons["Add"].tap()
        cancelButton.tap()
        coordinatesButton.tap()
        
        // Tap the add tree button from the coordinates screen
        let coordinatesNavigationBar = app.navigationBars["Coordinates"]
        coordinatesNavigationBar.buttons["Add"].tap()
        cancelButton.tap()
        mapButton.tap()
        
        // Tap the add tree button from the map screen
        let mapNavigationBar = app.navigationBars["Map"]
        mapNavigationBar.buttons["Add"].tap()
        cancelButton.tap()
        qrCodeButton.tap()
        
        // Tap the add tree button from the QR code screen
        let qrCodeNavigationBar = app.navigationBars["QR Code"]
        qrCodeNavigationBar.buttons["Add"].tap()
        cancelButton.tap()
        homeButton.tap()
        
        // Tap the settings button from the home screen
        let button2 = homeNavigationBar.children(matching: .button).element(boundBy: 1)
        button2.tap()
        
        // Close settings
        let closeButton = app.navigationBars["Settings"].buttons["Close"]
        closeButton.tap()
        button.tap()
        
        // Tap the settings button from the button screen
        buttonNavigationBar.children(matching: .button).element(boundBy: 1).tap()
        closeButton.tap()
        coordinatesButton.tap()
        
        // Tap the settings button from the settings screen
        coordinatesNavigationBar.children(matching: .button).element(boundBy: 1).tap()
        closeButton.tap()
        mapButton.tap()
        
        // Tap the settings button from the map screen
        mapNavigationBar.children(matching: .button).element(boundBy: 1).tap()
        closeButton.tap()
        qrCodeButton.tap()
        
        // Tap the settings button from the QR code screen
        qrCodeNavigationBar.children(matching: .button).element(boundBy: 1).tap()
        closeButton.tap()
        homeButton.tap()
        
        // Test the sub-settings screens
        button2.tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Active data sources"]/*[[".cells.staticTexts[\"Active data sources\"]",".staticTexts[\"Active data sources\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["TreeSapIOS.DataSourceTableView"].buttons["Settings"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["More information"]/*[[".cells.staticTexts[\"More information\"]",".staticTexts[\"More information\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["More Information"].buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Close"].tap()
        
    }
    
    func testTreeDetailDisplay() {
        
        // Go to the Button tab
        app.tabBars.buttons["Button"].tap()
        // Tap the big button
        app.buttons["Press me!"].tap()
        
        // Assert that the correct tree is shown
        XCTAssertEqual(app.staticTexts["commonNameLabel"].label, "American Sycamore")
        
        // Swipe left twice
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.swipeLeft()
        element.swipeLeft()
        
        // Close the tree details
        app.navigationBars["Tree Details"].buttons["Button"].tap()
        
        // Open settings
        app.navigationBars["Button"].children(matching: .button).element(boundBy: 1).tap()
        
        // Set the only active data source to benefits
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Active data sources"]/*[[".cells.staticTexts[\"Active data sources\"]",".staticTexts[\"Active data sources\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Hope College Trees"]/*[[".cells.staticTexts[\"Hope College Trees\"]",".staticTexts[\"Hope College Trees\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Hope College i-Tree Data"]/*[[".cells.staticTexts[\"Hope College i-Tree Data\"]",".staticTexts[\"Hope College i-Tree Data\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["City of Holland Tree Inventory"]/*[[".cells.staticTexts[\"City of Holland Tree Inventory\"]",".staticTexts[\"City of Holland Tree Inventory\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // Set the max identification distance
        app.navigationBars["TreeSapIOS.DataSourceTableView"].buttons["Settings"].tap()
        tablesQuery2.cells.containing(.staticText, identifier:"Max identification distance").children(matching: .textField).element.tap()
        
        let deleteKey = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        deleteKey.tap()
        
        let key = app/*@START_MENU_TOKEN@*/.keys["9"]/*[[".keyboards.keys[\"9\"]",".keys[\"9\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        key.tap()
        key.tap()
        key.tap()
        key.tap()
        key.tap()
        key.tap()
        key.tap()
        key.tap()
        key.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards.buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery2.children(matching: .other)["BASIC SETTINGS"].children(matching: .other)["BASIC SETTINGS"].tap()
        
        // Close settings
        app.navigationBars["Settings"].buttons["Close"].tap()
        
        // Tab the big button again
        app.buttons["Press me!"].tap()
        
        // Assert that the correct tree is shown
        XCTAssertEqual(app.staticTexts["commonNameLabel"].label, "Blue Spruce")

        // Swipe left twice
        element.swipeLeft()
        element.swipeLeft()
        
        // Close the tree details
        app.navigationBars["Tree Details"].buttons["Button"].tap()

    }

}
