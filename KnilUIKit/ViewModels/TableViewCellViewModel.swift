//
//  TableViewCellViewModel.swift
//  Knil
//
//  Created by Ethanhuang on 2018/6/25.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit

typealias UIViewControllerClosure = () -> UIViewController?
typealias Closure = () -> Void

public struct TableViewCellViewModel {
    let title: String
    let subtitle: String?
    let image: UIImage?
    let reuseIdentifier: String
    let cellStyle: UITableViewCellStyle
    let selectionStyle: UITableViewCellSelectionStyle
    let accessoryType: UITableViewCellAccessoryType
    let editActions: [UITableViewRowAction]
    var selectAction: Closure

    init(title: String,
         subtitle: String? = nil,
         image: UIImage? = nil,
         cellStyle: UITableViewCellStyle = .default,
         selectionStyle: UITableViewCellSelectionStyle = .default,
         accessoryType: UITableViewCellAccessoryType = .disclosureIndicator,
         editActions: [UITableViewRowAction] = [],
         selectAction: @escaping Closure = {}
        ) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.cellStyle = cellStyle
        self.reuseIdentifier = String(cellStyle.rawValue)
        self.selectionStyle = selectionStyle
        self.accessoryType = accessoryType
        self.editActions = editActions
        self.selectAction = selectAction
    }

    func configure(_ cell: UITableViewCell) {
        cell.textLabel?.text = title
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = subtitle
        cell.detailTextLabel?.numberOfLines = 0

        if let image = self.image {
            cell.imageView?.image = image

            let itemSize = CGSize(width: 44, height: 44)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
            let imageRect = CGRect(origin: .zero, size: itemSize)
            cell.imageView?.image?.draw(in: imageRect)
            cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }

        cell.selectionStyle = selectionStyle
        cell.accessoryType = accessoryType
    }
}
