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

struct TableViewCellViewModel {
    let title: String
    let subtitle: String?
    let reuseIdentifier: String
    let cellStyle: UITableViewCellStyle
    let selectionStyle: UITableViewCellSelectionStyle
    let accessoryType: UITableViewCellAccessoryType
//    var leadingSwipeActions: UISwipeActionsConfiguration?
//    var trailingSwipeActions: UISwipeActionsConfiguration?
    var previewingViewController: UIViewControllerClosure?
    var selectAction: Closure

    init(title: String,
         subtitle: String? = nil,
         cellStyle: UITableViewCellStyle = .default,
         selectionStyle: UITableViewCellSelectionStyle = .default,
         accessoryType: UITableViewCellAccessoryType = .disclosureIndicator,
//         leadingSwipeActions: UISwipeActionsConfiguration? = nil,
//         trailingSwipeActions: UISwipeActionsConfiguration? = nil,
         previewingViewController: UIViewControllerClosure? = nil,
         selectAction: @escaping Closure = {}
        ) {
        self.title = title
        self.subtitle = subtitle
        self.cellStyle = cellStyle
        self.reuseIdentifier = String(cellStyle.rawValue)
        self.selectionStyle = selectionStyle
        self.accessoryType = accessoryType
//        self.leadingSwipeActions = leadingSwipeActions
//        self.trailingSwipeActions = trailingSwipeActions
        self.previewingViewController = previewingViewController
        self.selectAction = selectAction
    }

    func configure(_ cell: UITableViewCell) {
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        cell.selectionStyle = selectionStyle
        cell.accessoryType = accessoryType
    }
}
