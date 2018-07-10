//
//  Errors.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public enum KnilKitError: Error {
    case initError

    /// For apps that run in iOS 9.3.1 and later, the uncompressed size of the apple-app-site-association file must be no greater than 128 KB, regardless of whether the file is signed.
    case fileSizeTooLarge

    /// Don’t append .json to the apple-app-site-association filename
    case hasFileExtension
}
