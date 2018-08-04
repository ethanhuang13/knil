//
//  UITableView+Extension.swift
//  KnilUIKit
//
//  Created by Ethanhuang on 2018/8/4.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit

extension UITableView {
    func performUpdates(_ updates: () -> Void, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)

        beginUpdates()
        updates()
        endUpdates()

        CATransaction.commit()
    }
}
