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
        
        app.navigationBars["Home"].buttons["Add"].tap()
    }
    
    func testTreeAdd(){
        app.alerts["Login required"].buttons["Log In"].tap()

        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 0).children(matching: .textField).element.tap()
        
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
        
        element.children(matching: .other).element(boundBy: 1).children(matching: .secureTextField).element.tap()
        
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
    }
    
    func testExample() {
        app.alerts["Login required"].buttons["Log In"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 0).children(matching: .textField).element.tap()//tap email field
        element.children(matching: .other).element(boundBy: 1).children(matching: .secureTextField).element.tap()//tap password field
    }
}
