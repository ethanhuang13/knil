//
//  iTunesApp.swift
//  Knil
//
//  Created by Ethanhuang on 2018/6/25.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct iTunesApp: Codable {
    public let appStoreURL: URL
    public let bundleID: String
    public let appName: String
    public let iconURL: URL

    enum CodingKeys: String, CodingKey {
        case appStoreURL = "trackViewUrl"
        case bundleID = "bundleId"
        case appName = "trackName"
        case iconURL = "artworkUrl512"
    }
}
