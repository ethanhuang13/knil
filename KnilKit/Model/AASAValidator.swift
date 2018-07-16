//
//  AASAValidator.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/12.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct AASAValidator {
    static func validate(_ aasa: AASA) -> Set<AASAValidatorError> {
        var errors: Set<AASAValidatorError> = []

        if let appLinks = aasa.appLinks {
            if appLinks.apps?.isEmpty == false {
                errors.insert(.appsMustEmptyArray)
            }
        } else {
            errors.insert(.noAppLinks)
        }

        return errors
    }
}
