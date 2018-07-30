//
//  AppPath.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

/// Note that only the path component of the URL is used for comparison. Other components, such as the query string or fragment identifier, are ignored.
public struct AppPath: Codable {
    /// The strings you use to specify website paths is case sensitive.
    public let pathString: String
    public let excluded: Bool

    public init(from decoder: Decoder) throws {
        let values = try decoder.singleValueContainer()
        let string = try values.decode(String.self)

        if string.hasPrefix("NOT ") {
            excluded = true
            pathString = string.replacingOccurrences(of: "NOT ", with: "")
        } else {
            excluded = false
            pathString = string
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let string = (excluded ? "NOT " : "") + pathString
        try container.encode(string)
    }
}

extension AppPath {
    public func url(hostname: Hostname) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = hostname

        if pathString == "*" {
            urlComponents.path = ""
        } else {
            urlComponents.path = pathString
        }
        return urlComponents.url
    }
}
