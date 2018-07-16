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

    public init(aasa: AASA, from url: URL) {
        self.aasa = aasa
        self.fetchedDate = Date()
        self.url = url
        self.hostname = url.host ?? ""
    }
}
