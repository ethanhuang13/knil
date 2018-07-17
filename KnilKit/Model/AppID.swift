//
//  AppID.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct AppID: Codable, Hashable {
    public let teamID: String
    public let bundleID: String

    public init?(string: String) {
        let substrings = string.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true)

        if let first = substrings.first,
            let last = substrings.last,
            first != last {
            teamID = String(first)
            bundleID = String(last)
        } else {
            return nil
        }
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.singleValueContainer()
        let string = try values.decode(String.self)

        let substrings = string.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: true)

        if let first = substrings.first,
            let last = substrings.last,
            first != last {
            teamID = String(first)
            bundleID = String(last)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "AppID decode invalid"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(appID)
    }

    public var appID: String {
        return teamID + "." + bundleID
    }
}
