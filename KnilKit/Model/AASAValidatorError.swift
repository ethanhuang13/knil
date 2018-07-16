//
//  AASAValidatorError.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/12.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public enum AASAValidatorError: Error {
    case fileSizeTooLarge
    case hasFileExtension
    case noAppLinks
    case appsMustEmptyArray
}

extension AASAValidatorError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fileSizeTooLarge:
            return "For apps that run in iOS 9.3.1 and later, the uncompressed size of the apple-app-site-association file must be no greater than 128 KB, regardless of whether the file is signed."
        case .hasFileExtension:
            return "Don’t append .json to the apple-app-site-association filename"
        case .noAppLinks:
            return "This AASA has no applinks object"
        case .appsMustEmptyArray:
            return "The apps key in an apple-app-site-association file must be present and its value must be an empty array"
        }
    }
}
