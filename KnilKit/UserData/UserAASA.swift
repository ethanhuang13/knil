//
//  UserAASA.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/16.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public class UserAASA: Codable {
    public let aasa: AASA
    public let fetchedDate: Date
    public let url: URL
    public let hostname: String
    public let userApps: [UserAppID]

    public init(aasa: AASA, from url: URL) {
        self.aasa = aasa
        self.fetchedDate = Date()
        self.url = url
        self.hostname = url.host ?? ""
        self.userApps = UserAASA.extractUserApps(from: aasa, hostname: hostname)
    }

    private static func extractUserApps(from aasa: AASA, hostname: String) -> [UserAppID] {
        var set: Set<AppID> = []
        set.formUnion(aasa.appLinks?.details.compactMap({ $0.appID }) ?? [])
        set.formUnion(aasa.webCredentials?.appIDs ?? [])
        set.formUnion(aasa.activityContinuation?.appIDs ?? [])
        return set.sorted(by: { $0.bundleID < $1.bundleID }).map { UserAppID(hostname: hostname, appID: $0, aasa: aasa) }
    }
}
