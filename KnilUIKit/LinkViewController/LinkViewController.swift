//
//  LinkViewController.swift
//  KnilUIKit
//
//  Created by Ethanhuang on 2018/7/17.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import KnilKit

class LinkViewController: UITableViewController {
    public var urlOpener: URLOpener?
    private lazy var viewModel: TableViewViewModel = { TableViewViewModel(tableViewController: self) }()
    private let userApp: UserApp

    init(userApp: UserApp) {
        self.userApp = userApp
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = .barTint
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.tint]
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.tint]
        }

        reloadData()
    }

    private func reloadData() {
        DispatchQueue.main.async {
            if let rows = self.userApp.paths?.map({ $0.cellViewModel(hostname: self.userApp.hostname, urlOpener: self.urlOpener) }) {
                let section = TableViewSectionViewModel(header: "Universal Link", footer: "Make sure you have the app installed. Tap each path to test, swipe left to edit.", rows: rows)
                self.viewModel.sections = [section]
            }

            self.navigationItem.title = self.userApp.app?.appName ?? self.userApp.appID.bundleID
        }
    }
}

