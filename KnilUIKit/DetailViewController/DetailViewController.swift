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
import SafariServices

/// AASA Detail
class DetailViewController: UITableViewController {
    public var urlOpener: URLOpener?
    private lazy var viewModel: TableViewViewModel = { TableViewViewModel(tableViewController: self) }()
    private let userAASA: UserAASA

    init(userAASA: UserAASA) {
        self.userAASA = userAASA
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let group = DispatchGroup()
        userAASA.userApps.forEach {
            group.enter()
            $0.fetchAll(completion: { (_) in
                group.leave()
            })}
        group.notify(queue: .main, execute: {
            self.reloadData()
        })

        reloadData()

        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingAASAAlertController)) // TODO: Adds custom paths
    }

    private func reloadData() {
        DispatchQueue.main.async {
            let userAASA = self.userAASA
            var sections: [TableViewSectionViewModel] = []

            // Title section
            let titleRow = TableViewCellViewModel(title: userAASA.cellTitle, subtitle: userAASA.cellSubtitle, cellStyle: .subtitle, selectionStyle: .default, accessoryType: .disclosureIndicator, previewingViewController: nil, selectAction: { })
            let searchAPIValidationRow = TableViewCellViewModel(title: "Open in App Search API Validation Tool", subtitle: "Tap here will copy an URL and open a webpage of Apple. You need to paste the URL to test.", cellStyle: .subtitle, previewingViewController: nil, selectAction: {
                self.openInSearchAPIValidation(hostname: userAASA.hostname)
            })
            let aasaValidatorRow = TableViewCellViewModel(title: "Open in AASA Validator", subtitle: "Tap here will open a webpage of Branch.io.", cellStyle: .subtitle, previewingViewController: nil, selectAction: {
                self.openInAASAValidator(hostname: userAASA.hostname)
            })
            let titleSection = TableViewSectionViewModel(header: "apple-app-site-association file", footer: nil, rows: [titleRow, searchAPIValidationRow, aasaValidatorRow])
            sections.append(titleSection)

            let hasOnlyOneApp = userAASA.userApps.count == 1

            // Sections for each AppID
            self.userAASA.userApps.forEach { userAppID in
                var rows: [TableViewCellViewModel] = []

                if let app = userAppID.app,
                    let icon = userAppID.icon {
                    let appRow = TableViewCellViewModel(title: app.appName, image: icon, cellStyle: .default, previewingViewController: nil, selectAction: {
                        self.download(userAppID.appID)
                    })

                    rows.append(appRow)
                }

                let appIDRow = TableViewCellViewModel(title: userAppID.cellTitle, subtitle: userAppID.cellSubtitle, cellStyle: .subtitle, selectionStyle: .none, accessoryType: .none, previewingViewController: nil, selectAction: { })
                rows.append(appIDRow)

                if hasOnlyOneApp == false,
                    userAppID.supportsAppLinks {
                    let row = TableViewCellViewModel(title: "Test Universal Link", previewingViewController: nil, selectAction: {
                        self.showLinkViewController(userApp: userAppID)
                    })
                    rows.append(row)
                }

                let section = TableViewSectionViewModel(header: userAppID.appID.bundleID, footer: nil, rows: rows)
                sections.append(section)
            }

            // If only one app and supports Universal Link, list
            if hasOnlyOneApp,
                let appPaths = userAASA.userApps.first?.paths {
                let rows = appPaths.map { $0.cellViewModel(hostname: userAASA.hostname, urlOpener: self.urlOpener) }
                let section = TableViewSectionViewModel(header: "Test Universal Link", footer: "Make sure you have the app installed. Tap each path to test, swipe left to edit.", rows: rows)
                sections.append(section)
            }

            self.navigationItem.title = self.userAASA.hostname

            self.viewModel.sections = sections
            self.tableView.reloadData()
        }
    }

    private func download(_ appID: AppID) {
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
    }

    private func openInSearchAPIValidation(hostname: String) {
        DispatchQueue.main.async {
            UIPasteboard.general.string = hostname
            let url = URL(string: "https://search.developer.apple.com/appsearch-validation-tool")!

            if let urlOpener = self.urlOpener {
                _ = urlOpener.openURL(url)
            } else {
                let sfvc = SFSafariViewController(url: url)
                //            sfvc.preferredBarTintColor = .barTintColor
                //            sfvc.preferredControlTintColor = .tintColor
                self.present(sfvc, animated: true, completion: { })
            }
        }
    }

    private func openInAASAValidator(hostname: String) {
        DispatchQueue.main.async {
            let url = URL(string: "https://branch.io/resources/aasa-validator/?domain=\(hostname)")!

            if let urlOpener = self.urlOpener {
                _ = urlOpener.openURL(url)
            } else {
                let sfvc = SFSafariViewController(url: url)
                //            sfvc.preferredBarTintColor = .barTintColor
                //            sfvc.preferredControlTintColor = .tintColor
                self.present(sfvc, animated: true, completion: { })
            }
        }
    }

    private func showLinkViewController(userApp: UserAppID) {
        DispatchQueue.main.async {
            let vc = LinkViewController(userApp: userApp)
            vc.urlOpener = self.urlOpener
            self.navigationController?.show(vc, sender: self)
        }
    }
}

extension DetailViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: { })
    }
}
