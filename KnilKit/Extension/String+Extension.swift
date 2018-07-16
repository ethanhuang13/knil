//
//  String+Extension.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/12.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

extension String {
    public func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

    public func caseInsensitiveHasPrefix(_ string: String) -> Bool {
        return self.lowercased().hasPrefix(string.lowercased())
    }

    public func caseInsensitiveHasSuffix(_ string: String) -> Bool {
        return self.lowercased().hasSuffix(string.lowercased())
    }
}
