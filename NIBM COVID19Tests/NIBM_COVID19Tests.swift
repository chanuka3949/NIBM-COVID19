//
//  NIBM_COVID19Tests.swift
//  NIBM COVID19Tests
//
//  Created by Chanuka on 8/20/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import XCTest
@testable import NIBM_COVID19

class NIBM_COVID19Tests: XCTestCase {
    
    let settingsVC = SettingsViewController()
    
    override func setUpWithError() throws {
        settingsVC.handleSignOut()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    func testAuthentication1() throws {
        //sample data
        let email = "davy.jones@email.com"
        let password = "jones@123"
        let firstName = "Davy"
        let lastName = "Jones"
        let role = 0
        
        let user = User(email: email, firstName: firstName, lastName: lastName, password: password, role: role)
        
        let signUpVC = SignUpViewController()
        
        let exp = expectation(description: "Successful Sign Up will give a true boolean output")
        
        signUpVC.signUpUser(user: user) { (userData, isSuccess) in
            XCTAssertTrue(isSuccess)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testAuthentication2() throws {

        //sample data
        let email = "davy.jones@email.com"
        let password = "jones@123"
        
        let signInVC = SignInViewController()
        
        let exp = expectation(description: "Successful Sign In will give a true boolean output")
        
        signInVC.signInUser(email: email, password: password, completion: { isSuccess in
            XCTAssertTrue(isSuccess)
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testAuthentication3() throws {
        //sample data
        let email = ""
        let password = ""
        
        let signInVC = SignInViewController()
        
        let exp = expectation(description: "Unsuccessful Sign In will give a false boolean output")
        
        signInVC.signInUser(email: email, password: password, completion: { isSuccess in
            XCTAssertFalse(isSuccess)
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
