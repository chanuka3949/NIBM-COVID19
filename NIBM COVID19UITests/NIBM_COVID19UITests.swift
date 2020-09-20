//
//  NIBM_COVID19UITests.swift
//  NIBM COVID19UITests
//
//  Created by Chanuka on 8/20/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import XCTest

class NIBM_COVID19UITests: XCTestCase {
    
    override func setUpWithError() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.tabBars.buttons["Settings"].tap()
        
        if app.staticTexts["Sign Out"].exists {
            app.staticTexts["Sign Out"].tap()
        }
        
        continueAfterFailure = false
        
    }
    
    override func tearDownWithError() throws {
    }
    
    func testSignIn() {
        let app = XCUIApplication()
        app.launch()
        
        let closeButton = app.buttons["╳"]
        let signUpWithEmailButton = app.buttons["Sign Up with Email"]
        let alreadyHaveAnAccountButton = app.buttons["Already have an account?"]
        let emailTextField = app.textFields["Email"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        let signInButton = app.buttons["Sign In"]
        let needAnAccountButton = app.buttons["Need an account?"]
        let homeScreenNavBarTitle = XCUIApplication().navigationBars["Summary"].staticTexts["Summary"]
        
        XCTAssertFalse(signUpWithEmailButton.exists)
        XCTAssertFalse(signUpWithEmailButton.exists)
        XCTAssertFalse(alreadyHaveAnAccountButton.exists)
        XCTAssertFalse(emailTextField.exists)
        XCTAssertFalse(passwordSecureTextField.exists)
        XCTAssertFalse(signInButton.exists)
        XCTAssertFalse(needAnAccountButton.exists)
        
        app.tabBars.buttons["Update"].tap()
        
        XCTAssertTrue(signUpWithEmailButton.exists)
        XCTAssertTrue(alreadyHaveAnAccountButton.exists)
        XCTAssertTrue(closeButton.exists)
        
        app.buttons["Already have an account?"].tap()
        
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordSecureTextField.exists)
        XCTAssertTrue(signInButton.exists)
        XCTAssertTrue(needAnAccountButton.exists)
        
        emailTextField.tap()
        passwordSecureTextField.tap()
        
        app.buttons["Sign In"].tap()
        
        if signInButton.isSelected {
            XCTAssertTrue(homeScreenNavBarTitle.exists)
        }
    }
    
    func testSingUp() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        let closeButton = app.buttons["╳"]
        let signUpWithEmailButton = app.buttons["Sign Up with Email"]
        let alreadyHaveAnAccountButton = app.buttons["Already have an account?"]
        let firstNameTextField = app.textFields["First Name"]
        let lastNameTextField = app.textFields["Last Name"]
        let emailTextField = app.textFields["Email"]
        let roleSegmentControlStudent = app.buttons["Student"]
        let roleSegmentControlStaff = app.buttons["Student"]
        let passwordSecureTextField = app.secureTextFields["Password"]
        let homeScreenNavBarTitle = XCUIApplication().navigationBars["Summary"].staticTexts["Summary"]
        let signUpButton = app.buttons["Sign Up"]
        
        XCTAssertFalse(signUpWithEmailButton.exists)
        XCTAssertFalse(lastNameTextField.exists)
        XCTAssertFalse(emailTextField.exists)
        XCTAssertFalse(passwordSecureTextField.exists)
        XCTAssertFalse(roleSegmentControlStudent.exists)
        XCTAssertFalse(roleSegmentControlStaff.exists)
        
        app.tabBars.buttons["Update"].tap()
        
        XCTAssertTrue(signUpWithEmailButton.exists)
        XCTAssertTrue(alreadyHaveAnAccountButton.exists)
        XCTAssertTrue(closeButton.exists)
        
        app.buttons["Sign Up with Email"].tap()
        
        XCTAssertTrue(signUpWithEmailButton.exists)
        XCTAssertTrue(lastNameTextField.exists)
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordSecureTextField.exists)
        XCTAssertTrue(roleSegmentControlStudent.exists)
        XCTAssertTrue(roleSegmentControlStaff.exists)
        
        firstNameTextField.tap()
        lastNameTextField.tap()
        emailTextField.tap()
        app.buttons["Student"].tap()
        passwordSecureTextField.tap()
        
        app.buttons["Sign Up"].tap()
        
        if signUpButton.isSelected {
            XCTAssertTrue(homeScreenNavBarTitle.exists)
        }
    }
    //
    //    func testLaunchPerformance() throws {
    //        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
    //            // This measures how long it takes to launch your application.
    //            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
    //                XCUIApplication().launch()
    //            }
    //        }
    //    }
}
