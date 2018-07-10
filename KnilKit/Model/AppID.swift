//
//  AppID.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct AppID: Codable {
    public let teamID: String
    public let bundleID: String

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
            throw KnilKitError.initError
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let string = teamID + "." + bundleID
        try container.encode(string)
    }
}
