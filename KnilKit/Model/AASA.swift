//
//  AASA.swift
//  Knil
//
//  Created by Ethanhuang on 2018/6/25.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct AASA: Codable {
    public let appLinks: AppLinks?
    public let webCredentials: AppIDsWrapper?
    public let activityContinuation: AppIDsWrapper?

    public enum CodingKeys: String, CodingKey {
        case appLinks = "applinks"
        case webCredentials = "webcredentials"
        case activityContinuation = "activitycontinuation"
    }
}
