//
//  DetailViewController.swift
//  KnilUIKit
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import KnilKit
import StoreKit

/// AASA Detail
class DetailViewController: UITableViewController {
    public var urlOpener: URLOpener?
    private lazy var viewModel: TableViewViewModel = { TableViewViewModel(tableViewController: self) }()
    private let userAASA: UserAASA

    init(userAASA: UserAASA) {
        self.userAASA = userAASA
        super.init(style: .grouped)

        reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func reloadData() {
        DispatchQueue.main.async {
            /*
             title
             app links
                app 1
                    download link
                    path
                    path
                app 2
                    download link
                    path
                    path
             web credential
                 AppID
                 AppID
             activity continuity
                 AppID
                 AppID
             */

            let aasa = self.userAASA.aasa
            var sections: [TableViewSectionViewModel] = []

            if let appLinks = aasa.appLinks {
                let appLinkSections: [TableViewSectionViewModel] = appLinks.details.map { appDetail in
                    let appID = appDetail.appID
                    let appIDRow = TableViewCellViewModel(title: appID.bundleID, subtitle: appID.teamID, cellStyle: .subtitle, previewingViewController: nil, selectAction: {
                        iTunesSearchAPI.searchApp(bundleID: appID.bundleID, completion: { (result) in
                            DispatchQueue.main.async {
                                switch result {
                                case .value(let app):
                                    if let urlOpener = self.urlOpener {
                                        _ = urlOpener.openURL(app.appStoreURL)
                                    } else {
                                        let vc = SKStoreProductViewController()
                                        vc.delegate = self
                                        vc.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: app.productID], completionBlock: { (result, error) in
                                            if let error = error {
                                                print(error.localizedDescription)
                                            } else {
                                                DispatchQueue.main.async {
                                                    self.present(vc, animated: true, completion: { })
                                                }
                                            }
                                        })
                                    }
                                case .error(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        })
                    })

                    let rows = appDetail.paths.map { appPath in
                        return TableViewCellViewModel(title: appPath.excluded ? "NOT \(appPath.pathString)" : appPath.pathString, subtitle: appPath.pathString, cellStyle: .default, previewingViewController: nil, selectAction: {

                            if let url = appPath.url(hostname: self.userAASA.hostname),
                                let urlOpener = self.urlOpener {
                                _ = urlOpener.openURL(url)
                            }
                        })
                    }

                    return TableViewSectionViewModel(header: appID.bundleID, footer: nil, rows: [appIDRow] + rows)
                }

                sections.append(contentsOf: appLinkSections)

//                let appLinksSection = TableViewSectionViewModel(header: "App Links", footer: nil, rows: [])
            }

            if let webCredentials = aasa.webCredentials {
                let rows = webCredentials.appIDs.map { appID in
                    TableViewCellViewModel(title: appID.bundleID, subtitle: appID.teamID, cellStyle: .subtitle, selectionStyle: .none, accessoryType: .none, previewingViewController: nil, selectAction: { })
                }

                let webCredentialsSection = TableViewSectionViewModel(header: "Web Credentials", footer: nil, rows: rows)
                sections.append(webCredentialsSection)
            }

            if let activityContinuation = aasa.activityContinuation {
                let rows = activityContinuation.appIDs.map { appID in
                    TableViewCellViewModel(title: appID.bundleID, subtitle: appID.teamID, cellStyle: .subtitle, selectionStyle: .none, accessoryType: .none, previewingViewController: nil, selectAction: { })
                }

                let activityContinuationSection = TableViewSectionViewModel(header: "Activity Continuation", footer: nil, rows: rows)
                sections.append(activityContinuationSection)
            }

            self.navigationItem.title = self.userAASA.hostname

            self.viewModel.sections = sections
            self.tableView.reloadData()
        }
    }
}

extension DetailViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: { })
    }
}
