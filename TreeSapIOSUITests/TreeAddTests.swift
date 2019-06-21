//
//  TreeAddTest.swift
//  TreeSapIOSUITests
//
//  Created by Research on 6/20/19.
//  Copyright © 2019 Hope CS. All rights reserved.
//

import XCTest

class TreeAddTest: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = UIDeviceOrientation.portrait
        
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        
        let addTreeButton = app.navigationBars["Home"].buttons["Add"]
        let exists = NSPredicate(format: "exists == 1")
        let addTreeExpectation = expectation(for: exists, evaluatedWith: addTreeButton, handler: nil)
        wait(for: [addTreeExpectation], timeout: 8)
        addTreeButton.tap()
    }
    
    ///Log the user in if necessary. Fail if the login interface is invalid
    func logInIfNecessary(){
        let loginRequriedAlertButton = app.alerts["Login required"].buttons["Log In"]
        guard loginRequriedAlertButton.exists && loginRequriedAlertButton.isHittable else {
            return
        }
        
        loginRequriedAlertButton.tap()
        app.textFields["Log In Email"].tap()
        
        //Type in e-mail
        app.keys["e"].tap()
        app.keys["x"].tap()
        app.keys["a"].tap()
        app.keys["m"].tap()
        app.keys["p"].tap()
        app.keys["l"].tap()
        app.keys["e"].tap()
        app.keys["@"].tap()
        app.keys["e"].tap()
        app.keys["x"].tap()
        app.keys["a"].tap()
        app.keys["m"].tap()
        app.keys["p"].tap()
        app.keys["l"].tap()
        app.keys["e"].tap()
        app.keys["."].tap()
        app.keys["c"].tap()
        app.keys["o"].tap()
        app.keys["m"].tap()
        
        app.buttons["Next"].tap()
        
        //Type in password
        app.keys["t"].tap()
        app.keys["h"].tap()
        app.keys["i"].tap()
        app.keys["n"].tap()
        app.keys["g"].tap()
        app.keys["y"].tap()
        app.keys["shift"].tap()
        app.keys["T"].tap()
        app.keys["h"].tap()
        app.keys["i"].tap()
        app.keys["n"].tap()
        app.keys["g"].tap()
        app.keys["y"].tap()
        
        //Log in
        app.buttons["Go"].tap()
    }
    
    ///Tests that a tree can be added with the bare minimum requirements. Uses the device location. Skips adding pictures, and does not add any additional information. This adds an empty tree every time it runs, if it does not fail.
    func testTreeAddGeneral(){
        app.buttons["Use Current Location"].tap()
        app.buttons["Next"].tap()
        app.buttons["Skip"].tap()
        app.buttons["Skip"].tap()
        app.buttons["Skip"].tap()
        app.buttons["Done"].tap()
        app.alerts["Submit tree for approval?"].buttons["OK"].tap()
    }
    
    ///Tests that a tree can be added. Uses the device location. Skips adding pictures. Fills out all optional information.
    func testTreeAddAllOtherInformation(){
        app.buttons["Use Current Location"].tap()
        app.buttons["Next"].tap()
        app.buttons["Skip"].tap()
        app.buttons["Skip"].tap()
        app.buttons["Skip"].tap()
        
        app.textFields["Common Name Text"].tap()
        
        //Type in the common name of the tree
        app.keys["T"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
        app.keys["space"].tap()
        app.keys["C"].tap()
        app.keys["o"].tap()
        app.keys["m"].tap()
        app.keys["m"].tap()
        app.keys["o"].tap()
        app.keys["n"].tap()
        app.keys["space"].tap()
        app.keys["N"].tap()
        app.keys["a"].tap()
        app.keys["m"].tap()
        app.keys["e"].tap()
        
        app.buttons["Next"].tap()
        
        //Type in the scientific name of the tree
        app.keys["T"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
        app.keys["space"].tap()
        app.keys["s"].tap()
        app.keys["c"].tap()
        app.keys["i"].tap()
        app.keys["e"].tap()
        app.keys["n"].tap()
        app.keys["t"].tap()
        app.keys["i"].tap()
        app.keys["f"].tap()
        app.keys["i"].tap()
        app.keys["c"].tap()
        app.keys["space"].tap()
        app.keys["n"].tap()
        app.keys["a"].tap()
        app.keys["m"].tap()
        app.keys["e"].tap()
        
        app.buttons["Next"].tap()
        
        //Type in the first DBH measurement
        app.keys["1"].tap()
        app.keys["0"].tap()
        
        let addDBHButton = app.buttons["Add DBH Measurement"]
        addDBHButton.tap()
        app.textFields["Circumference Text 1"].tap()
        
        //Type in the second circumference measurement
        app.keys["-"].tap()
        app.keys["2"].tap()
        app.keys["3"].tap()
        
        app.staticTexts["Classification Information"].tap()
        addDBHButton.tap()
        app.textFields["DBH Text 2"].tap()
        
        //Type in the third DBH measurment
        app.keys["4"].tap()
        app.keys["5"].tap()
        app.keys["."].tap()
        app.keys["6"].tap()
        app.keys["?"].tap()
        
        app.staticTexts["Classification Information"].tap()
        addDBHButton.tap()
        app.textFields["DBH Text 3"].tap()
        
        //Type in the fourth DBH measurement
        app.keys["7"].tap()
        app.keys["8"].tap()
        
        //Press the "Go" button/key to add the tree
        app.buttons["Go"].tap()
        app.alerts["Submit tree for approval?"].buttons["OK"].tap()
    }
}
