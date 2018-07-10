//
//  AppLinksTests.swift
//  KnilKitTests
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import XCTest
@testable import KnilKit

class AppLinksTests: XCTestCase {
    
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
            {
                "apps": [],
                "details": [
                  {
                    "appID": "YV88822DH9.com.twitter.dogfood.internal",
                    "paths": [
                      "NOT /about",
                      "/account/confirm_email_reset",
                      "/account/login-token",
                      "NOT /account/*",
                      "NOT /adspolicy",
                      "NOT /api_rules",
                      "NOT /apirules",
                      "NOT /applications",
                      "NOT /apps",
                      "NOT /blog",
                      "NOT /bouncers/reset",
                      "NOT /download",
                      "NOT /downloads",
                      "NOT /faq",
                      "NOT /goodies",
                      "NOT /help/*",
                      "NOT /intent/sessions",
                      "NOT /i/commerce/merchants/*/privacy_policy",
                      "NOT /i/donate/*",
                      "NOT /i/u",
                      "NOT /jobs",
                      "NOT /login/*",
                      "NOT /logo",
                      "NOT /logout",
                      "NOT /newtwitter",
                      "NOT /oauth/*",
                      "NOT /privacy",
                      "NOT /*/privacy",
                      "NOT /pw_rst",
                      "NOT /rules",
                      "NOT /session/*",
                      "NOT /sessions/*",
                      "/settings/accessibility",
                      "/settings/account",
                      "/settings/devices",
                      "/settings/email_notifications",
                      "/settings/password",
                      "/settings/personalization",
                      "/settings/safety",
                      "/settings/your_twitter_data",
                      "NOT /settings/*",
                      "NOT /signup/*",
                      "NOT /terms",
                      "NOT /tos",
                      "NOT /*/tos",
                      "NOT /transparency",
                      "NOT /tweetbutton",
                      "NOT /unlock_account/*",
                      "NOT /user_spam_reports",
                      "NOT /users/email_available",
                      "NOT /users/phone_number_available",
                      "/*"
                    ]
                  },
                  {
                    "appID": "YV88822DH9.com.twitter.Twitter.beta.crashlytics",
                    "paths": [
                      "NOT /about",
                      "/account/confirm_email_reset",
                      "/account/login-token",
                      "NOT /account/*",
                      "NOT /adspolicy",
                      "NOT /api_rules",
                      "NOT /apirules",
                      "NOT /applications",
                      "NOT /apps",
                      "NOT /blog",
                      "NOT /bouncers/reset",
                      "NOT /download",
                      "NOT /downloads",
                      "NOT /faq",
                      "NOT /goodies",
                      "NOT /help/*",
                      "NOT /intent/sessions",
                      "NOT /i/commerce/merchants/*/privacy_policy",
                      "NOT /i/donate/*",
                      "NOT /i/u",
                      "NOT /jobs",
                      "NOT /login/*",
                      "NOT /logo",
                      "NOT /logout",
                      "NOT /newtwitter",
                      "NOT /oauth/*",
                      "NOT /privacy",
                      "NOT /*/privacy",
                      "NOT /pw_rst",
                      "NOT /rules",
                      "NOT /session/*",
                      "NOT /sessions/*",
                      "/settings/accessibility",
                      "/settings/account",
                      "/settings/devices",
                      "/settings/email_notifications",
                      "/settings/password",
                      "/settings/personalization",
                      "/settings/safety",
                      "/settings/your_twitter_data",
                      "NOT /settings/*",
                      "NOT /signup/*",
                      "NOT /terms",
                      "NOT /tos",
                      "NOT /*/tos",
                      "NOT /transparency",
                      "NOT /tweetbutton",
                      "NOT /unlock_account/*",
                      "NOT /user_spam_reports",
                      "NOT /users/email_available",
                      "NOT /users/phone_number_available",
                      "/*"
                    ]
                  },
                  {
                    "appID": "8248RGMF2D.com.atebits.Tweetie2",
                    "paths": [
                      "NOT /about",
                      "/account/confirm_email_reset",
                      "/account/login-token",
                      "NOT /account/*",
                      "NOT /adspolicy",
                      "NOT /api_rules",
                      "NOT /apirules",
                      "NOT /applications",
                      "NOT /apps",
                      "NOT /blog",
                      "NOT /bouncers/reset",
                      "NOT /download",
                      "NOT /downloads",
                      "NOT /faq",
                      "NOT /goodies",
                      "NOT /help/*",
                      "NOT /intent/sessions",
                      "NOT /i/commerce/merchants/*/privacy_policy",
                      "NOT /i/donate/*",
                      "NOT /i/u",
                      "NOT /jobs",
                      "NOT /login/*",
                      "NOT /logo",
                      "NOT /logout",
                      "NOT /newtwitter",
                      "NOT /oauth/*",
                      "NOT /privacy",
                      "NOT /*/privacy",
                      "NOT /pw_rst",
                      "NOT /rules",
                      "NOT /session/*",
                      "NOT /sessions/*",
                      "/settings/accessibility",
                      "/settings/account",
                      "/settings/devices",
                      "/settings/email_notifications",
                      "/settings/password",
                      "/settings/personalization",
                      "/settings/safety",
                      "/settings/your_twitter_data",
                      "NOT /settings/*",
                      "NOT /signup/*",
                      "NOT /terms",
                      "NOT /tos",
                      "NOT /*/tos",
                      "NOT /transparency",
                      "NOT /tweetbutton",
                      "NOT /unlock_account/*",
                      "NOT /user_spam_reports",
                      "NOT /users/email_available",
                      "NOT /users/phone_number_available",
                      "/*"
                    ]
                  }
                ]
              }
        """

        let testData = testString.data(using: .utf8)!

        let appLinks = try? JSONDecoder().decode(AppLinks.self, from: testData)
        XCTAssertNotNil(appLinks)
        XCTAssert(appLinks?.details.count == 3)
    }
}
