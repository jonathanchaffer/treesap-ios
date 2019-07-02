//
//  TreeSapIOSUITests.swift
//  TreeSapIOSUITests
//
//  Created by Josiah Brett in Summer 2019.
//  Copyright © 2019 Hope CS. All rights reserved.
//

@testable import TreeSapIOS
import UIKit
import XCTest

class TreeSapIOSUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()

        // Waits for a navigation bar to exist
        let navigationBar = app.navigationBars.firstMatch
        let exists = NSPredicate(format: "exists == 1")
        let navigationBarExpectation = expectation(for: exists, evaluatedWith: navigationBar, handler: nil)
        wait(for: [navigationBarExpectation], timeout: 5)
    }

    override func tearDown() {}

    func testNavigation() {
        // Tap the button tab
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Identify"].tap()

        // Tap the coordinates tab
        tabBarsQuery.buttons["Coordinates"].tap()

        // Tap the map tab
        tabBarsQuery.buttons["Map"].tap()

        // Tap the QR code tab
        tabBarsQuery.buttons["QR Code"].tap()

        // Tap the home tab
        tabBarsQuery.buttons["Home"].tap()

        // Tap the add tree button from the home screen
        app.navigationBars["Home"].buttons["add tree"].tap()

        // Close the add tree screen
        let cancelLoginAlertButton = app.alerts["Login required"].buttons["Cancel"]
        if cancelLoginAlertButton.exists {
            cancelLoginAlertButton.tap()
        } else {
            app.navigationBars["Add Tree"].buttons["Close"].tap()
        }

        // Tap the add tree button from the identify screen
        tabBarsQuery.buttons["Identify"].tap()
        app.navigationBars["Identify"].buttons["add tree"].tap()

        // Close the add tree screen
        if cancelLoginAlertButton.exists {
            cancelLoginAlertButton.tap()
        } else {
            app.navigationBars["Add Tree"].buttons["Close"].tap()
        }

        // Tap the add tree button from the coordinates screen
        app.tabBars.buttons["Coordinates"].tap()
        app.navigationBars["Coordinates"].buttons["add tree"].tap()

        // Close the add tree screen
        if cancelLoginAlertButton.exists {
            cancelLoginAlertButton.tap()
        } else {
            app.navigationBars["Add Tree"].buttons["Close"].tap()
        }

        // Tap the add tree button from the map screen
        app.tabBars.buttons["Map"].tap()
        app.navigationBars["Map"].buttons["add tree"].tap()

        // Close the add tree screen
        if cancelLoginAlertButton.exists {
            cancelLoginAlertButton.tap()
        } else {
            app.navigationBars["Add Tree"].buttons["Close"].tap()
        }

        // Tap the add tree button from the QR code screen
        app.tabBars.buttons["QR Code"].tap()
        app.navigationBars["QR Code"].buttons["add tree"].tap()

        // Close the add tree screen
        if cancelLoginAlertButton.exists {
            cancelLoginAlertButton.tap()
        } else {
            app.navigationBars["Add Tree"].buttons["Close"].tap()
        }

//        // Tap the settings button from the home screen
//        app.tabBars.buttons["Home"].tap()
//        app.navigationBars["Home"].buttons["settings"].tap()
//
//        // Close settings
//        let closeButton = app.navigationBars["settings"].buttons["Close"]
//        closeButton.tap()
//
//        // Tap the settings button from the identify screen, and then close the settings screen
//        tabBarsQuery.buttons["Identify"].tap()
//        app.navigationBars["Identify"].buttons["settings"].tap()
//        closeButton.tap()
//
//        // Tap the settings button from the coordinates screen, and then close the settings screen
//        tabBarsQuery.buttons["Coordinates"].tap()
//        app.navigationBars["Coordinates"].buttons["settings"].tap()
//        closeButton.tap()
//
//        // Tap the settings button from the map screen, and then close the settings screen
//        tabBarsQuery.buttons["Map"].tap()
//        app.navigationBars["Map"].buttons["settings"].tap()
//        closeButton.tap()
//
//        // Tap the settings button from the QR code screen
//        tabBarsQuery.buttons["QR Code"].tap()
//        app.navigationBars["QR code"].buttons["settings"].tap()
//
//        // Test the sub-settings screens
//        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Active data sources"]/*[[".cells.staticTexts[\"Active data sources\"]",".staticTexts[\"Active data sources\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.navigationBars["TreeSapIOS.DataSourceTableView"].buttons["settings"].tap()
//        app.tables/*@START_MENU_TOKEN@*/.staticTexts["More information"]/*[[".cells.staticTexts[\"More information\"]",".staticTexts[\"More information\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        app.navigationBars["More Information"].buttons["settings"].tap()
//        app.navigationBars["settings"].buttons["Close"].tap()
    }

    // Only works if one is in the correct location. This is designed to be used from the computer science lab at Hope College
    func testTreeDetailDisplay() {
        // Go to the Identify tab
        app.tabBars.buttons["Identify"].tap()
        // Tap the big button
        app.buttons["identify tree"].tap()

        // Swipe left twice
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.swipeLeft()
        element.swipeLeft()

        // Close the tree details
        app.navigationBars["Tree Details"].buttons["Identify"].tap()

        // Open settings
        app.navigationBars["Identify"].buttons["settings"].tap()

        // Set the only active data source to benefits
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Active data sources"]/*[[".cells.staticTexts[\"Active data sources\"]",".staticTexts[\"Active data sources\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Hope College Trees"]/*[[".cells.staticTexts[\"Hope College Trees\"]",".staticTexts[\"Hope College Trees\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Hope College i-Tree Data"]/*[[".cells.staticTexts[\"Hope College i-Tree Data\"]",".staticTexts[\"Hope College i-Tree Data\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["City of Holland Tree Inventory"]/*[[".cells.staticTexts[\"City of Holland Tree Inventory\"]",".staticTexts[\"City of Holland Tree Inventory\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        // Set the max identification distance
        app.navigationBars["Active Data Sources"].buttons["Settings"].tap()
        let maxIDDistanceTextField = tablesQuery.cells.containing(.staticText, identifier: "Max identification distance").children(matching: .textField).element
        maxIDDistanceTextField.tap()

        app.buttons["Clear text"].tap()

        // Get the current max identification distance
        let startingMaxIDString = maxIDDistanceTextField.value as! String

        // Set the max identification distance to a new value
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

        // check that the max identification distance in the text field is correct
        var maxIDString = maxIDDistanceTextField.value as! String
        XCTAssertEqual(maxIDString, "9999999999")

        // Change the max identification distance back to the starting value and check that it was correctly changed back
        maxIDDistanceTextField.tap()
        maxIDDistanceTextField.buttons["Clear text"].tap()
        maxIDDistanceTextField.typeText(startingMaxIDString)
        maxIDString = maxIDDistanceTextField.value as! String
        XCTAssertEqual(maxIDString, startingMaxIDString)

        // Change the max identification distance back to what it was

        tablesQuery.children(matching: .other)["BASIC SETTINGS"].children(matching: .other)["BASIC SETTINGS"].tap()

        // Close settings
        app.navigationBars["Settings"].buttons["Close"].tap()

        // Tab the big button again
        app.buttons["identify tree"].tap()

        // Swipe left twice
        element.swipeLeft()
        element.swipeLeft()

        // Close the tree details
        app.navigationBars["Tree Details"].buttons["Identify"].tap()
    }

    func closeAddTreeFirstScreen() {}
}
