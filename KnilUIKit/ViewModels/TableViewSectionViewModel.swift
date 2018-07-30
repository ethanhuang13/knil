//
//  TableViewSectionViewModel.swift
//  Knil
//
//  Created by Ethanhuang on 2018/6/24.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct TableViewSectionViewModel {
    public let header: String?
    public let footer: String?
    public let rows: [TableViewCellViewModel]
}
