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

protocol DetailViewControllerDelegate: class {
    func update(_ userAASA: UserAASA)
}

/// AASA Detail
class DetailViewController: UITableViewController {
    public var urlOpener: URLOpener?
    internal weak var delegate: DetailViewControllerDelegate?
    private lazy var viewModel: TableViewViewModel = { TableViewViewModel(tableViewController: self) }()
    private var userAASA: UserAASA

    init(userAASA: UserAASA) {
        self.userAASA = userAASA
        super.init(style: .grouped)
        hidesBottomBarWhenPushed = true
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingCustomURLAlertController))
    }

    private func update(_ userAASA: UserAASA) {
        self.userAASA = userAASA
        reloadData()
    }

    private func reloadData() {
        DispatchQueue.main.async {
            let userAASA = self.userAASA
            var sections: [TableViewSectionViewModel] = []

            // Title section
            let titleRow = TableViewCellViewModel(title: userAASA.cellTitle, subtitle: userAASA.cellSubtitle, cellStyle: .subtitle, selectionStyle: .none, accessoryType: .none, selectAction: { })
            let aasaActionsRow = TableViewCellViewModel(title: "Actions".localized(), subtitle: "Open in other tools, see raw file, or reload.".localized(), cellStyle: .subtitle, selectAction: {
                let alertController = UIAlertController(title: userAASA.url.absoluteString, message: nil, preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "Open App Search API Validation Tool".localized(), style: .default, handler: { (_) in
                    self.openInSearchAPIValidation(hostname: userAASA.hostname)
                }))
                alertController.addAction(UIAlertAction(title: "Open in AASA Validator".localized(), style: .default, handler: { (_) in
                    self.openInAASAValidator(hostname: userAASA.hostname)
                }))
                alertController.addAction(UIAlertAction(title: "See Raw File in the Browser".localized(), style: .default, handler: { (_) in
                    self.seeRaw()
                }))
                alertController.addAction(UIAlertAction(title: "Reload".localized(), style: .default, handler: { (_) in
                    self.reloadAASA()
                }))

                alertController.addAction(.cancelAction)
                self.present(alertController, animated: true, completion: { })
            })

            let titleSection = TableViewSectionViewModel(header: "apple-app-site-association file".localized(), footer: nil, rows: [titleRow, aasaActionsRow])
            sections.append(titleSection)

            // Custom URLs
            let emptyRow = TableViewCellViewModel(title: "Add Link".localized(), selectAction: {
                self.presentAddingCustomURLAlertController()
            })
            let customLinkRows: [TableViewCellViewModel] = userAASA.customURLs.map { url in
                let removeAction = UITableViewRowAction(style: .destructive, title: "Remove".localized(), handler: { (_, _) in
                    DispatchQueue.main.async {
                        if let index = userAASA.customURLs.index(of: url) {
                            userAASA.customURLs.remove(at: index)
                            self.reloadData()
                        }
                    }
                })

                return TableViewCellViewModel(title: url.relativePath, editActions: [removeAction], selectAction: {
                    _ = self.urlOpener?.openURL(url)
                })
            }
            let customLinksSection = TableViewSectionViewModel(header: "Custom Links".localized(), footer: "Add custom links for Universal Link testing.".localized(), rows: customLinkRows.isEmpty ? [emptyRow] : customLinkRows)

            sections.append(customLinksSection)

            /*
            let hasOnlyOneApp = userAASA.userApps.count == 1
             */

            // Sections for each AppID
            self.userAASA.userApps.forEach { userAppID in
                var rows: [TableViewCellViewModel] = []

                if let app = userAppID.app,
                    let icon = userAppID.icon {
                    let appRow = TableViewCellViewModel(title: app.appName, image: icon, cellStyle: .default, selectAction: {
                        self.download(userAppID.appID)
                    })

                    rows.append(appRow)
                }

                let appIDRow = TableViewCellViewModel(title: userAppID.cellTitle, subtitle: userAppID.cellSubtitle, cellStyle: .subtitle, selectionStyle: .none, accessoryType: .none, selectAction: { })
                rows.append(appIDRow)

                if //hasOnlyOneApp == false,
                    userAppID.supportsAppLinks {
                    let row = TableViewCellViewModel(title: "Universal Link".localized(), selectAction: {
                        self.showLinkViewController(userApp: userAppID)
                    })
                    rows.append(row)
                }

                let section = TableViewSectionViewModel(header: userAppID.appID.bundleID, footer: nil, rows: rows)
                sections.append(section)
            }

            /*
            // If only one app and supports Universal Link, list
            if hasOnlyOneApp,
                let appPaths = userAASA.userApps.first?.paths {
                let rows = appPaths.map { $0.cellViewModel(hostname: userAASA.hostname, urlOpener: self.urlOpener) }
                let section = TableViewSectionViewModel(header: "Universal Link", footer: "Make sure you have the app installed. Tap each path to test, swipe left to edit.", rows: rows)
                sections.append(section)
            }
             */

            self.navigationItem.title = self.userAASA.hostname

            self.viewModel.sections = sections
            self.tableView.reloadData()
        }
    }

    @objc private func presentAddingCustomURLAlertController() {
        // TODO: Upgrade to a full function URL builder.
        /*
         Inlcuding:
         - path
         - parameter-value pairs
         */

        let alertController = UIAlertController(title: "Add Universal Link Test".localized(), message: "Type in a path and parameters for \(userAASA.hostname)", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = "/"
            textField.placeholder = "/path/"
            textField.clearButtonMode = .always
        }

        alertController.addAction(UIAlertAction(title: "Go".localized(), style: .default, handler: { (_) in
            guard let string = alertController.textFields?.first?.text else {
                fatalError("Missing textField")
            }

            guard var urlComponents = URLComponents(url: self.userAASA.url, resolvingAgainstBaseURL: false) else {
                return
            }

            urlComponents.path = string

            if let url = urlComponents.url {
                self.userAASA.customURLs.append(url)
                self.reloadData()
            }
        }))
        alertController.addAction(.cancelAction)
        present(alertController, animated: true, completion: { })
    }

    private func download(_ appID: AppID) {
        iTunesSearchAPI.searchApp(bundleID: appID.bundleID, completion: { (result) in
            DispatchQueue.main.async {
                switch result {
                case .value(let app):
                    if UserDefaults.standard.appStoreOption == .appStore,
                        let urlOpener = self.urlOpener {
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
            let alertController = UIAlertController(title: "App Search Validation Tool", message: "You will need to paste the URL yourself.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Go".localized(), style: .default, handler: { (_) in
                UIPasteboard.general.string = hostname
                let url = URL(string: "https://search.developer.apple.com/appsearch-validation-tool")!

                if let urlOpener = self.urlOpener {
                    _ = urlOpener.openURL(url)
                } else {
                    let sfvc = SFSafariViewController(url: url)
                    if #available(iOSApplicationExtension 10.0, *) {
                        sfvc.preferredBarTintColor = .barTint
                        sfvc.preferredControlTintColor = .tint
                    }
                    self.present(sfvc, animated: true, completion: { })
                }
            }))

            alertController.addAction(.cancelAction)
            self.present(alertController, animated: true, completion: { })
        }
    }

    private func openInAASAValidator(hostname: String) {
        DispatchQueue.main.async {
            let url = URL(string: "https://branch.io/resources/aasa-validator/?domain=\(hostname)")!

            if let urlOpener = self.urlOpener {
                _ = urlOpener.openURL(url)
            } else {
                let sfvc = SFSafariViewController(url: url)
                if #available(iOSApplicationExtension 10.0, *) {
                    sfvc.preferredBarTintColor = .barTint
                    sfvc.preferredControlTintColor = .tint
                }
                self.present(sfvc, animated: true, completion: { })
            }
        }
    }

    private func showLinkViewController(userApp: UserApp) {
        DispatchQueue.main.async {
            let vc = LinkViewController(userApp: userApp)
            vc.urlOpener = self.urlOpener
            self.navigationController?.show(vc, sender: self)
        }
    }

    private func seeRaw() {
        let sfvc = SFSafariViewController(url: userAASA.url)
        self.present(sfvc, animated: true, completion: { })
    }

    private func reloadAASA() {
        let url = userAASA.url
        AASAFetcher.fetch(url: url, completion: { (result) in
            DispatchQueue.main.async {
                switch result {
                case .value(let (aasa, _)):
                    self.userAASA.update(aasa)
                    self.delegate?.update(self.userAASA)
                    self.present(UIAlertController.okAlertController(title: "Done".localized(), message: ""), animated: true, completion: nil)

                    let group = DispatchGroup()
                    self.userAASA.userApps.forEach {
                        group.enter()
                        $0.fetchAll(completion: { (_) in
                            group.leave()
                        })}
                    group.notify(queue: .main, execute: {
                        self.reloadData()
                    })

                case .error(let error):
                    self.present(UIAlertController.cancelAlertController(title: "Error".localized(), message: error.localizedDescription), animated: true, completion: nil)
                }
            }
        })
    }
}

extension DetailViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: { })
    }
}
