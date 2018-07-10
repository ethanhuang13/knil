//
//  AppDetail.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct AppDetail: Codable {
    public let appID: AppID

    /// Because the system evaluates each path in the paths array in the order it is specified—and stops evaluating when a positive or negative match is found—you should specify high priority paths before low priority paths. 
    public let paths: [AppPath]
}

