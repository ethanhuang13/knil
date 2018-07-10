//
//  AASATests.swift
//  KnilKitTests
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import XCTest
@testable import KnilKit

class AASATests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUnsignedDecode() {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: "test-AASA-unsigned", withExtension: nil) else {
            fatalError("Missing file URL: test-AASA-unsigned")
        }

        do {
            let testData = try Data(contentsOf: fileURL)
            let aasa = try JSONDecoder().decode(AASA.self, from: testData)
            XCTAssertNotNil(aasa)
            XCTAssertNotNil(aasa.appLinks)
            XCTAssertNotNil(aasa.webCredentials)
            XCTAssertNotNil(aasa.activityContinuation)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testSignedDecode() {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: "test-AASA-signed", withExtension: nil) else {
            fatalError("Missing file URL: test-AASA-signed")
        }

        do {
            let testData = try Data(contentsOf: fileURL)
            let aasa = try JSONDecoder().decode(AASA.self, from: testData)
            XCTAssertNotNil(aasa)
            XCTAssertNotNil(aasa.appLinks)
            XCTAssertNotNil(aasa.webCredentials)
            XCTAssertNotNil(aasa.activityContinuation)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
