//
//  Errors.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public enum KnilKitError: Error {
    case invalidURLString(String)
    case noData
    case cannotFetchFile(String)
}

extension KnilKitError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURLString(let urlString):
            return "Invalid URL: \(urlString)."
        case .noData:
            return "Sorry, no data."
        case .cannotFetchFile(let urlString):
            return "Cannot fetch the file from \(urlString)."
        }
    }
}
