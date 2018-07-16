//
//  URLOpener.swift
//  KnilUIKit
//
//  Created by Ethanhuang on 2018/7/16.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public protocol URLOpener {
    func openURL(_ url: URL) -> Bool
}
