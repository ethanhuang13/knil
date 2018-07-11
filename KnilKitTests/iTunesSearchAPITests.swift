//
//  iTunesSearchAPITests.swift
//  KnilKitTests
//
//  Created by Ethanhuang on 2018/7/11.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import XCTest
@testable import KnilKit

class iTunesSearchAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBundleIDs() {
        let bundleIDs: [String] = ["com.atebits.Tweetie2",
                                   "com.facebook.Messenger",
                                   "com.facebook.PageAdminApp",
                                   "com.facebook.Facebook",
                                   "com.facebook.atwork",
                                   "com.catchplay.AsiaPlay",
                                   "com.netflix.Netflix",
                                   "com.burbn.instagram",
                                   "com.yelp.yelpiphone",
                                   "com.amazon.Amazon",
                                   "com.getdropbox.Dropbox",
                                   "com.airbnb.app",
                                   "com.google.Maps",
                                   "com.medium.reader",
                                   "fm.overcast.overcast",
                                   "com.imdb.imdb"]
        let expectations = bundleIDs.map { XCTestExpectation(description: $0) }

        for (index, bundleID) in bundleIDs.enumerated() {
            iTunesSearchAPI.searchApp(bundleID: bundleID) { (result) in
                switch result {
                case .value(let app):
                    print(app)
                    expectations[index].fulfill()
                case .error(let error):
                    XCTFail(bundleID + ". " + error.localizedDescription)
                }
            }
        }

        wait(for: expectations, timeout: 5.0)
    }
}
