//
//  AppPathTests.swift
//  KnilKitTests
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import XCTest
@testable import KnilKit

class AppPathTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDecode() {
        let testString = """
          ["NOT /about",
          "/account/confirm_email_reset",
          "/account/login-token",
          "NOT /account/*"]
"""

        let testData = testString.data(using: .utf8)!

        let paths: [String] = [
            "/about",
            "/account/confirm_email_reset",
            "/account/login-token",
            "/account/*"
        ]

        let excludeds: [Bool] = [
            true,
            false,
            false,
            true
        ]

        let appPaths = try? JSONDecoder().decode([AppPath].self, from: testData)

        for (index, appPath) in appPaths!.enumerated() {
            XCTAssertEqual(appPath.pathString, paths[index])
            XCTAssertEqual(appPath.excluded, excludeds[index])
        }
    }

    func testEncode() {
        let testString = """
          ["NOT /about",
          "/account/confirm_email_reset",
          "/account/login-token",
          "NOT /account/*"]
        """

        let testData = testString.data(using: .utf8)!

        do {
            let appPaths = try JSONDecoder().decode([AppPath].self, from: testData)
            XCTAssertNotNil(appPaths)

            let encodedData = try JSONEncoder().encode(appPaths)
            let appPaths2 = try JSONDecoder().decode([AppPath].self, from: encodedData)

            for index in 0...appPaths.count - 1 {
                XCTAssertEqual(appPaths[index].excluded, appPaths2[index].excluded)
                XCTAssertEqual(appPaths[index].pathString, appPaths2[index].pathString)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
