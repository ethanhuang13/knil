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
    private let userApp: UserAppID

    init(userApp: UserAppID) {
        self.userApp = userApp
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
    }

    private func reloadData() {
        DispatchQueue.main.async {
            if let rows = self.userApp.paths?.map({ $0.cellViewModel(hostname: self.userApp.hostname, urlOpener: self.urlOpener) }) {
                let section = TableViewSectionViewModel(header: "Test Universal Link", footer: "Make sure you have the app installed. Tap each path to test, swipe left to edit.", rows: rows)
                self.viewModel.sections = [section]
            }

            self.navigationItem.title = self.userApp.app?.appName ?? self.userApp.appID.bundleID
        }
    }
}

