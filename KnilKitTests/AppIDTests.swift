//
//  AppIDTests.swift
//  KnilKitTests
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import XCTest
@testable import KnilKit

class AppIDTests: XCTestCase {
    
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
            ["YV88822DH9.com.twitter.dogfood.internal",
            "YV88822DH9.com.twitter.Twitter.beta.crashlytics",
            "8248RGMF2D.com.atebits.Tweetie2",
            "T84QZS65DQ.com.facebook.Facebook",
            "T84QZS65DQ.com.facebook.Wilde",
            "3NW3KR6Q88.com.facebook.FacebookDevelopment",
            "3NW3KR6Q88.com.facebook.WildeInHouse"]
        """

        let testData = testString.data(using: .utf8)!

        let teamIDs = ["YV88822DH9",
                       "YV88822DH9",
                       "8248RGMF2D",
                       "T84QZS65DQ",
                       "T84QZS65DQ",
                       "3NW3KR6Q88",
                       "3NW3KR6Q88"]

        let bundleIDs = ["com.twitter.dogfood.internal",
                         "com.twitter.Twitter.beta.crashlytics",
                         "com.atebits.Tweetie2",
                         "com.facebook.Facebook",
                         "com.facebook.Wilde",
                         "com.facebook.FacebookDevelopment",
                         "com.facebook.WildeInHouse"]

        let appIDs = try! JSONDecoder().decode([AppID].self, from: testData)

        for (index, appID) in appIDs.enumerated() {
            XCTAssertEqual(appID.teamID, teamIDs[index])
            XCTAssertEqual(appID.bundleID, bundleIDs[index])
        }
    }

    func testEncode() {
        let testString = """
            ["YV88822DH9.com.twitter.dogfood.internal",
            "YV88822DH9.com.twitter.Twitter.beta.crashlytics",
            "8248RGMF2D.com.atebits.Tweetie2",
            "T84QZS65DQ.com.facebook.Facebook",
            "T84QZS65DQ.com.facebook.Wilde",
            "3NW3KR6Q88.com.facebook.FacebookDevelopment",
            "3NW3KR6Q88.com.facebook.WildeInHouse"]
        """

        let testData = testString.data(using: .utf8)!

        do {
            let appIDs = try JSONDecoder().decode([AppID].self, from: testData)
            XCTAssertNotNil(appIDs)

            let encodedData = try JSONEncoder().encode(appIDs)
            let appIDs2 = try JSONDecoder().decode([AppID].self, from: encodedData)

            for index in 0...appIDs.count - 1 {
                XCTAssertEqual(appIDs[index].teamID, appIDs2[index].teamID)
                XCTAssertEqual(appIDs[index].bundleID, appIDs2[index].bundleID)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
