//
//  URLComponents+Extension.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/8/1.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

extension URLComponents {
    public var urlString: String {
        return url?.absoluteString ?? ""
    }

    // TODO: Tests
    public var pathComponents: [String] {
        get {
            return path.components(separatedBy: "/").filter { $0.isEmpty == false }
        }
        set {
            let newPath = newValue.filter({ $0.isEmpty == false }).joined(separator: "/")
            if newPath.hasPrefix("/")
                || newPath.isEmpty {
                path = newPath
            } else {
                path = "/" + newPath
            }
        }
    }
}
