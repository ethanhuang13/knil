//
//  AppPath+Extension.swift
//  KnilUIKit
//
//  Created by Ethanhuang on 2018/7/17.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation
import KnilKit

extension AppPath {
    var cellTitle: String {
        return excluded ? "NOT \(pathString)" : pathString
    }
}
