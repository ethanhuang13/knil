//
//  TableViewViewModel.swift
//  Knil
//
//  Created by Ethanhuang on 2018/6/24.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit

public class TableViewViewModel: NSObject, UITableViewDataSource, UITableViewDelegate {
    public var sections: [TableViewSectionViewModel] = []
    private weak var tableViewController: UITableViewController?

    public init(tableViewController: UITableViewController) {
        super.init()
        self.tableViewController = tableViewController
        self.tableViewController?.tableView.dataSource = self
        self.tableViewController?.tableView.delegate = self
    }

    // MARK: - UITableViewDataSource

    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }

    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = sections[indexPath.section].rows[indexPath.row]
        let identifier = cellViewModel.reuseIdentifier
        let cell = UITableViewCell(style: cellViewModel.cellStyle, reuseIdentifier: identifier)
        cellViewModel.configure(cell)

        return cell
    }

    // MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cellViewModel = sections[indexPath.section].rows[indexPath.row]
        cellViewModel.selectAction()
    }

    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let cellViewModel = sections[indexPath.section].rows[indexPath.row]
        cellViewModel.detailAction()
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let cellViewModel = sections[indexPath.section].rows[indexPath.row]
        return cellViewModel.editActions
    }
}
