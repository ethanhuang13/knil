//
//  AppLinks.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct AppLinks: Codable {
    /// The apps key in an apple-app-site-association file must be present and its value must be an empty array
    public let apps: [AppID]?
    public let details: [AppDetail]

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        apps = try values.decodeIfPresent([AppID].self, forKey: .apps)

        do {
            details = try values.decode([AppDetail].self, forKey: .details)
        } catch {
            if let detailsDict = try values.decodeIfPresent([String: [String: [AppPath]]].self, forKey: .details) {
                details = try detailsDict.map {
                    guard let appID = AppID(string: $0.key) else {
                        throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.details], debugDescription: "AppID decode invalid"))
                    }

                    guard let paths = $0.value["paths"] else {
                        throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.details], debugDescription: "AppDetail decode invalid"))
                    }

                    return AppDetail(appID: appID, paths: paths)
                }
            } else {
                throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.details], debugDescription: "AppDetail decode invalid"))
            }
        }

    }
}
