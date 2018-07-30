//
//  AASAURLSuggestorTests.swift
//  KnilKitTests
//
//  Created by Ethanhuang on 2018/7/30.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import XCTest
@testable import KnilKit

class AASAURLSuggestorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSuggestURL() {
        let cases: [String: String] = [
            "twitter": "https://www.twitter.com/apple-app-site-association",
            "twitter.com": "https://twitter.com/apple-app-site-association",
            "www.twitter.com": "https://www.twitter.com/apple-app-site-association",
            "www.twitter.com/apple-app-site-association": "https://www.twitter.com/apple-app-site-association",
            "https://www.twitter.com/apple-app-site-association": "https://www.twitter.com/apple-app-site-association",
            "spotify": "https://open.spotify.com/apple-app-site-association",
            "https://netflix.com/title": "https://netflix.com/apple-app-site-association",
            "netflix.com/title": "https://netflix.com/apple-app-site-association",
            "https://netflix.com/title?test=123": "https://netflix.com/apple-app-site-association",
            "netflix.com/title?test=123": "https://netflix.com/apple-app-site-association",
        ]

        for (key, value) in cases {
            let suggested = AASAURLSuggestor.suggestURL(from: key)!.absoluteString
            XCTAssert(suggested == value, "Suggest for \(key) is \(suggested) but should be \(value).")
        }
    }
}
