//
//  LinkViewController.swift
//  KnilUIKit
//
//  Created by Ethanhuang on 2018/7/17.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import KnilKit

protocol LinkViewControllerDelegate: class {
    func duplicateLinkAndCompose(_ url: URL)
}

class LinkViewController: UITableViewController {
    public var urlOpener: URLOpener?
    internal weak var delegate: LinkViewControllerDelegate?
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
            if let rows = self.userApp.paths?.map ({ path in
                return TableViewCellViewModel(title: path.cellTitle, cellStyle: .default, accessoryType: .detailDisclosureButton, selectAction: {
                    if let url = path.url(hostname: self.userApp.hostname) {
                        _ = self.urlOpener?.openURL(url)
                    }
                }, detailAction: {
                    if let url = path.url(hostname: self.userApp.hostname) {
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                            self.navigationController?.transitionCoordinator?.animate(alongsideTransition: nil, completion: { (_) in
                                self.delegate?.duplicateLinkAndCompose(url)
                            })
                        }
                    }
                })
            }) {
                let section = TableViewSectionViewModel(header: "Universal Link".localized(), footer: "Make sure you have the app installed. Tap each link to test. If labelled with NOT, it should open in Safari. Otherwise, it should open in the app.\n\nTap (i) to duplicate and compose the link for custom testing.".localized(), rows: rows)
                self.viewModel.sections = [section]
            }

            self.navigationItem.title = self.userApp.app?.appName ?? self.userApp.appID.bundleID
        }
    }
}

