//
//  UserAASA+Extension.swift
//  KnilUIKit
//
//  Created by Ethanhuang on 2018/7/16.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation
import KnilKit

extension UserAASA {
    var cellTitle: String {
        return hostname
    }

    var cellSubtitle: String {
        let pairs: [(Int?, String)] = [
            (0, "🌎 \(url.absoluteString)"),
            (userApps.count, "💡 %li App ID(s)"),
            (aasa.appLinks?.details.count, "🔗 %li App Links"), // App Links
            (aasa.activityContinuation?.appIDs.count, "🤝 %li Activity Continuation"), // Activity Continuation
            (aasa.webCredentials?.appIDs.count, "🔐 %li Web Credentials") // Web Credentials
        ]

        return pairs.filter({ $0.0 != nil }).map ({ String(format: $0.1, $0.0!) }).joined(separator: "\n")
    }
}
