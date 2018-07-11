//
//  Result.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/11.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public enum Result<T> {
    case value(T)
    case error(Error)
}
