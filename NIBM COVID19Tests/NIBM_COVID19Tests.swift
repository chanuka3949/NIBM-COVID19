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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        
        //sample data
        
        
        let signInVC = SignInViewController()
        signInVC.signUpUser(email: <#T##String#>, password: <#T##String#>)
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
