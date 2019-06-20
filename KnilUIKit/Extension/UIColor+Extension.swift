//
//  UIColor+Extension.swift
//  KnilUIKit
//
//  Created by Ethanhuang on 2018/7/30.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit

extension UIColor {
    public static let tint: UIColor = #colorLiteral(red: 1, green: 0.5803921569, blue: 0.1450980392, alpha: 1)

    public static var barTint: UIColor {
        if #available(iOSApplicationExtension 13.0, *) {
            return .systemBackground
        } else {
            return .black
        }
    }

    public static var background: UIColor {
        if #available(iOSApplicationExtension 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }
}
