//
//  UIAlertController+Extension.swift
//  KnilUIKit
//
//  Created by Ethanhuang on 2018/7/25.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func okAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.okAction)
        return alertController
    }

    static func cancelAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(.cancelAction)
        return alertController
    }
}
