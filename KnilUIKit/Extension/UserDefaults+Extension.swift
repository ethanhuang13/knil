//
//  UserDefaults+Extension.swift
//  Knil
//
//  Created by Ethanhuang on 2018/7/30.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation
import KnilKit

extension UserDefaults {
    private static let appStoreOptionKey = "com.elaborapp.Knil.appStoreOptionKey"

    var appStoreOption: AppStoreOption {
        get {
            return AppStoreOption(rawValue: UserDefaults.standard.integer(forKey: UserDefaults.appStoreOptionKey)) ?? .appStore
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: UserDefaults.appStoreOptionKey)
        }
    }
}
