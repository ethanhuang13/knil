//
//  AppConstants.swift
//  Knil
//
//  Created by Ethanhuang on 2018/7/31.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

struct AppConstants {
    static let appName: String = "Knil"
    static var versionString: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    static var buildString: String = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    static var aboutString: String = "\(appName) v\(versionString)(\(buildString))"
    static var userAgentString: String = "\(appName)/\(versionString)"
    static var copyrightString: String = "2018 Elaborapp Co., Ltd."

    static var feedbackEmail: String = "elaborapp+knil@gmail.com"

    static var appStoreURL: URL = URL(string: "https://itunes.apple.com/us/app/knil-universal-link-testing/id1195310358?l=zh&ls=1&mt=8")!
    static var githubURL: URL = URL(string: "https://github.com/ethanhuang13/knil")!
    static var developerURL: URL = URL(string: "https://twitter.com/ethanhuang13")!
}
