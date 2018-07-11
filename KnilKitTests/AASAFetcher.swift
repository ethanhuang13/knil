//
//  AASAFetcherTests.swift
//  KnilKitTests
//
//  Created by Ethanhuang on 2018/7/11.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import XCTest
@testable import KnilKit

class AASAFetcherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFetchAASAs() {
        let hosts: [String] = [
            "twitter.com",
            "facebook.com",
            "netflix.com",
            "www.catchplay.com",
            "instagram.com",
            "yelp.com",
            "amazon.com",
            "pinterest.com",
            "www.opentable.com",
            "flipboard.com",
            "citymapper.com",
            "foursquare.com",
            "www.dropbox.com",
            "www.airbnb.com",
            "www.periscope.tv",
            "www.google.com",
            "medium.com",
            "overcast.fm",
            "www.swarmapp.com",
            "flickr.com",
            "www.shazam.com",
            "www.imdb.com",
            "www.nytimes.com",
            "linkedin.com",
            "open.spotify.com",
            "soundcloud.com" // Redirected to /.well-known/
        ]
        let expectations = hosts.map { XCTestExpectation(description: $0) }

        for (index, host) in hosts.enumerated() {
            AASAFetcher.fetch(host: host) { (result) in
                switch result {
                case .value(_):
                    expectations[index].fulfill()
                case .error(let error):
                    XCTFail(host + ". " + error.localizedDescription)
                }
            }
        }

        wait(for: expectations, timeout: 5.0)
    }
}
