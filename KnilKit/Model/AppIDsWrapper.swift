//
//  AppIDsWrapper.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct AppIDsWrapper: Codable {
    public let appIDs: [AppID]

    public enum CodingKeys: String, CodingKey {
        case appIDs = "apps"
    }
}
