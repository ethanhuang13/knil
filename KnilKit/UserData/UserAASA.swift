//
//  UserAASA.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/16.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public class UserAASA: Codable {
    public private(set) var aasa: AASA
    public let fetchedDate: Date
    public let url: URL
    public let hostname: String
    public let userApps: [UserApp]
    public var customURLs: [URL]

    public init(aasa: AASA, from url: URL) {
        self.aasa = aasa
        self.fetchedDate = Date()
        self.url = url
        self.hostname = url.host?.lowercased() ?? ""
        self.userApps = UserAASA.extractUserApps(from: aasa, hostname: hostname)
        self.customURLs = []
    }

    public func update(_ aasa: AASA) {
        print("UserAASA \(hostname) updated AASA")
        self.aasa = aasa

        let newUserApps = UserAASA.extractUserApps(from: aasa, hostname: hostname)
        for newUserApp in newUserApps {
            if let userApp = userApps.filter({ (userApp) -> Bool in
                return userApp.appID == newUserApp.appID
            }).first {
                userApp.update(paths: newUserApp.paths,
                               supportsAppLinks: newUserApp.supportsAppLinks,
                               supportsWebCredentials: newUserApp.supportsWebCredentials,
                               supportsActivityContinuation: newUserApp.supportsActivityContinuation)
            }
        }
    }

    private static func extractUserApps(from aasa: AASA, hostname: String) -> [UserApp] {
        var set: Set<AppID> = []
        set.formUnion(aasa.appLinks?.details.compactMap({ $0.appID }) ?? [])
        set.formUnion(aasa.webCredentials?.appIDs ?? [])
        set.formUnion(aasa.activityContinuation?.appIDs ?? [])
        return set.sorted(by: { $0.bundleID < $1.bundleID }).map { UserApp(hostname: hostname, appID: $0, aasa: aasa) }
    }
}
