//
//  TreeAddTest.swift
//  TreeSapIOSUITests
//
//  Created by Josiah Brett on 6/20/19.
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
        logInIfNecessary()
    }

    // MARK: Helper Methods in setUp()

    /// Log the user in if necessary. Fail if the login interface is invalid
    func logInIfNecessary() {
        let loginRequriedAlertButton = app.alerts["Login required"].buttons["Log In"]
        guard loginRequriedAlertButton.exists, loginRequriedAlertButton.isHittable else {
            return
        }

        loginRequriedAlertButton.tap()
        app.textFields["Log In Email"].tap()

        // Type in e-mail
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

        // Type in password
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

        // Log in
        app.buttons["Go"].tap()
    }

    // MARK: Other Details Page Tests

    /// Tests that a tree can be added with the bare minimum requirements. Uses the device location. Skips adding pictures, and does not add any additional information. This adds an empty tree every time it runs, if it does not fail.
    func testTreeAddGeneral() {
        app.buttons["Use Current Location"].tap()
        app.buttons["Next"].tap()
        app.buttons["Skip"].tap()
        app.buttons["Skip"].tap()
        app.buttons["Skip"].tap()
        app.buttons["Done"].tap()
        app.alerts["Submit tree for approval?"].buttons["OK"].tap()
    }

    /// Tests that a tree can be added. Uses the device location. Skips adding pictures. Fills out all optional information.
    func testTreeAddAllOtherInformation() {
        app.buttons["Use Current Location"].tap()
        app.buttons["Next"].tap()
        app.buttons["Skip"].tap()
        app.buttons["Skip"].tap()
        app.buttons["Skip"].tap()

        app.textFields["Common Name Text"].tap()

        // Type in the common name of the tree
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

        // Type in the scientific name of the tree
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

        // Type in the first DBH measurement
        app.keys["1"].tap()
        app.keys["0"].tap()

        let addDBHButton = app.buttons["Add DBH Measurement"]
        addDBHButton.tap()
        app.textFields["Circumference Text 1"].tap()

        // Type in the second circumference measurement
        app.keys["-"].tap()
        app.keys["2"].tap()
        app.keys["3"].tap()

        app.staticTexts["Classification Information"].tap()
        addDBHButton.tap()
        app.textFields["DBH Text 2"].tap()

        // Type in the third DBH measurment
        app.keys["4"].tap()
        app.keys["5"].tap()
        app.keys["."].tap()
        app.keys["6"].tap()
        app.keys["?"].tap()

        app.staticTexts["Classification Information"].tap()
        addDBHButton.tap()
        app.textFields["DBH Text 3"].tap()

        // Type in the fourth DBH measurement
        app.keys["7"].tap()
        app.keys["8"].tap()

        // Press "Done" to add the tree, and press "OK" on the following alerts
        app.buttons["Done"].tap()
        app.alerts["Submit tree for approval?"].buttons["OK"].tap()
        app.alerts["Success!"].buttons["OK"].tap()
    }

    // This test may not work
    /// Tests that only numbers, spaces and the character "." can be typed in the measurement text box by the user. Assumes that the the keyboard starts out with the numbers configuration (of the two configurations one can shift between using the more button).
    func testProperCharactersAllowedOtherDetailsScreen() {
        // Navigate to other details page
        app.buttons["Use Current Location"].tap()
        app.buttons["Next"].tap()
        app.buttons["Skip"].tap()
        app.buttons["Skip"].tap()
        app.buttons["Skip"].tap()

        // Add tree measurement text fields
        let addMeasurementButton: XCUIElement = app.buttons["Add DBH Measurement"]
        addMeasurementButton.tap()
        addMeasurementButton.tap()
        addMeasurementButton.tap()

        var checkedTextFields = [XCUIElement]()
        checkedTextFields.append(app.textFields["DBH Text 0"])
        checkedTextFields.append(app.textFields["Circumference Text 0"])
        checkedTextFields.append(app.textFields["DBH Text 1"])
        checkedTextFields.append(app.textFields["Circumference Text 1"])
        checkedTextFields.append(app.textFields["DBH Text 2"])
        checkedTextFields.append(app.textFields["Circumference Text 2"])
        checkedTextFields.append(app.textFields["DBH Text 3"])
        checkedTextFields.append(app.textFields["Circumference Text 3"])

        for textField in checkedTextFields {
            textField.tap()

            // Clear the text in the text field, if the clear text button is visible. The clear text button is only visible if the text field is being edited and there is text in the text field
            let clearTextButton = app.buttons["Clear text"]
            if clearTextButton.exists, clearTextButton.isHittable {
                clearTextButton.tap()
            }

            // Type in the text field using the allowed keys
            app.keys["1"].tap()
            app.keys["2"].tap()
            app.keys["3"].tap()
            app.keys["4"].tap()
            app.keys["5"].tap()
            app.keys["6"].tap()
            app.keys["7"].tap()
            app.keys["8"].tap()
            app.keys["9"].tap()
            app.keys["."].tap()
            app.keys["0"].tap()

            // Check that the correct string was typed
            guard let text = textField.value as? String else {
                let textFieldName: String = textField.accessibilityValue ?? "nil"
                XCTFail("The text field \"\(textFieldName)\" does not contain text.")
                return
            }
            XCTAssertEqual(text, "123456789.0", "The text field should contain the string \"123456789.0\", but contains the string \"\(text)\"")

            // Clear the text field
            let deleteButton = app.keys["delete"]
            for _ in 0 ..< 11 {
                deleteButton.tap()
            }

            // Type in the text field using the keys that are not allowed
            app.keys["-"].tap()
            app.keys["/"].tap()
            app.keys[":"].tap()
            app.keys[";"].tap()
            app.keys["("].tap()
            app.keys[")"].tap()
            app.keys["$"].tap()
            app.keys["ampersand"].tap()
            app.keys["@"].tap()
            app.keys["\""].tap()
            app.keys[","].tap()
            app.keys["?"].tap()
            app.keys["!"].tap()
            app.keys["-"].tap()
            app.keys["'"].tap()
            app.keys["space"].tap()
            app.buttons["shift"].tap()
            app.keys["["].tap()
            app.keys["]"].tap()
            app.keys["{"].tap()
            app.keys["}"].tap()
            app.keys["#"].tap()
            app.keys["%"].tap()
            app.keys["^"].tap()
            app.keys["*"].tap()
            app.keys["+"].tap()
            app.keys["="].tap()
            app.keys["_"].tap()
            app.keys["\\"].tap()
            app.keys["|"].tap()
            app.keys["~"].tap()
            app.keys["<"].tap()
            app.keys[">"].tap()
            app/*@START_MENU_TOKEN@*/.keys["€"]/*[[".keyboards.keys[\"€\"]",".keys[\"€\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app/*@START_MENU_TOKEN@*/.keys["£"]/*[[".keyboards.keys[\"£\"]",".keys[\"£\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app/*@START_MENU_TOKEN@*/.keys["¥"]/*[[".keyboards.keys[\"¥\"]",".keys[\"¥\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app/*@START_MENU_TOKEN@*/.keys["•"]/*[[".keyboards.keys[\"•\"]",".keys[\"•\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app.keys["more"].tap()
            app.keys["a"].tap()
            app.keys["b"].tap()
            app.keys["c"].tap()
            app.keys["d"].tap()
            app.keys["e"].tap()
            app.keys["f"].tap()
            app.keys["g"].tap()
            app.keys["h"].tap()
            app.keys["i"].tap()
            app.keys["j"].tap()
            app.keys["k"].tap()
            app.keys["l"].tap()
            app.keys["m"].tap()
            app.keys["n"].tap()
            app.keys["o"].tap()
            app.keys["p"].tap()
            app.keys["q"].tap()
            app.keys["r"].tap()
            app.keys["s"].tap()
            app.keys["t"].tap()
            app.keys["u"].tap()
            app.keys["v"].tap()
            app.keys["w"].tap()
            app.keys["x"].tap()
            app.keys["y"].tap()
            app.keys["z"].tap()
            app.buttons["shift"].tap()
            app.buttons["shift"].tap()
            app.keys["A"].tap()
            app.keys["B"].tap()
            app.keys["C"].tap()
            app.keys["D"].tap()
            app.keys["E"].tap()
            app.keys["F"].tap()
            app.keys["G"].tap()
            app.keys["H"].tap()
            app.keys["I"].tap()
            app.keys["J"].tap()
            app.keys["K"].tap()
            app.keys["L"].tap()
            app.keys["M"].tap()
            app.keys["N"].tap()
            app.keys["O"].tap()
            app.keys["P"].tap()
            app.keys["Q"].tap()
            app.keys["R"].tap()
            app.keys["S"].tap()
            app.keys["T"].tap()
            app.keys["U"].tap()
            app.keys["V"].tap()
            app.keys["W"].tap()
            app.keys["X"].tap()
            app.keys["Y"].tap()
            app.keys["Z"].tap()

            // Check that the text in the text field is still empty or equal to the placeholder text. If there is no text in the text field, attempting to access the text in the text field programmatically will result in the value of the placeholder text in the text field.
            guard let testText = textField.value as? String else {
                let textFieldName: String = textField.accessibilityValue ?? "nil"
                XCTFail("The text field \"\(textFieldName)\" does not contain text.")
                return
            }
            if testText != "" {
                guard let placeholderText: String = textField.placeholderValue else {
                    XCTFail()
                    return
                }
                if testText != placeholderText {
                    XCTFail("The text in the text field \"\(textField)\" is \"\(testText)\". The text field should be empty, or contain the placeholder text, \"\(placeholderText)\".")
                }
            }
        }
    }
}
