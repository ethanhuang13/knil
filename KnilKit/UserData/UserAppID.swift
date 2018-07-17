//
//  UserAppID.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/17.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public class UserAppID: Codable {
    public let hostname: String
    public let appID: AppID

    public private(set) var paths: [AppPath]?
    public private(set) var supportsAppLinks: Bool = false
    public private(set) var supportsWebCredentials: Bool = false
    public private(set) var supportsActivityContinuation: Bool = false

    public var app: iTunesApp?
    public var icon: UIImage?
    public var customPaths: [AppPath]?

    public enum CodingKeys: String, CodingKey {
        case hostname
        case appID
        case paths
        case supportsAppLinks
        case supportsWebCredentials
        case supportsActivityContinuation
    }

    public init(hostname: String, appID: AppID, aasa: AASA) {
        self.hostname = hostname
        self.appID = appID

        paths = aasa.appLinks?.details.filter { $0.appID == appID }.first?.paths
        supportsAppLinks = aasa.appLinks?.details.filter { $0.appID == appID }.first != nil
        supportsWebCredentials = aasa.webCredentials?.appIDs.contains(appID) == true
        supportsActivityContinuation = aasa.activityContinuation?.appIDs.contains(appID) == true
    }
}
