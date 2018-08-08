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

    init(userAASA: UserAASA, urlOpener: URLOpener?) {
        self.userAASA = userAASA
        self.urlOpener = urlOpener
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

        NotificationCenter.default.addObserver(self, selector: #selector(pasteboardDidChange), name: .UIPasteboardChanged, object: nil)

        reloadData()
    }

    @objc private func pasteboardDidChange() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }

    private func update(_ userAASA: UserAASA) {
        self.userAASA = userAASA
        reloadData()
    }

    private func reloadData() {
        DispatchQueue.main.async {
            self.navigationItem.title = self.userAASA.hostname
            self.viewModel.sections = [self.titleSection, self.customLinksSection] + self.appSections
            self.tableView.reloadData()
        }
    }

    private var titleSection: TableViewSectionViewModel {
        let userAASA = self.userAASA

        let titleRow = TableViewCellViewModel(title: userAASA.cellTitle, subtitle: userAASA.cellSubtitle, cellStyle: .subtitle, selectionStyle: .none, accessoryType: .none)
        let aasaActionsRow = TableViewCellViewModel(title: "Actions".localized(), subtitle: "Open in other tools, see raw file, or reload.".localized(), cellStyle: .subtitle, selectAction: {
            let alertController = UIAlertController(title: "Actions".localized(), message: userAASA.url.absoluteString, preferredStyle: .alert)

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
        return titleSection
    }

    private var customLinksSection: TableViewSectionViewModel {
        let userAASA = self.userAASA

        var rows: [TableViewCellViewModel] = []
        let customLinkRows: [TableViewCellViewModel] = userAASA.customURLs.sorted(by: { $0.key.absoluteString < $1.key.absoluteString }).map { pair in
            let url = pair.key
            let cellTitle = pair.value.isEmpty ? "(No Title)".localized() : pair.value

            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete".localized(), handler: { (_, _) in
                userAASA.customURLs.removeValue(forKey: pair.key)
                self.reloadData()
            })

            return TableViewCellViewModel(title: cellTitle, subtitle: url.relativePathAndQuery, cellStyle: .subtitle, accessoryType: .detailDisclosureButton, editActions: [deleteAction], selectAction: {
                _ = self.urlOpener?.openURL(url)
            }, detailAction: {
                self.composeLink(url, title: pair.value)
            })
        }
        rows.append(contentsOf: customLinkRows)

        let addCustomLinkRow = TableViewCellViewModel(title: "+ Add Link".localized(), selectAction: {
            guard let url = self.userAASA.url.deletingPathAndQuery() else {
                return
            }
            self.composeLink(url, title: "")
        })
        rows.append(addCustomLinkRow)

        if let pasteboardString = UIPasteboard.general.string,
            let url = URL(string: pasteboardString),
            url.host == self.userAASA.hostname {
            let pasteLinkRow = TableViewCellViewModel(title: "+ Add Link From Clipboard".localized(), subtitle: url.absoluteString, cellStyle: .subtitle, selectAction: {
                self.composeLink(url, title: "")
            })
            rows.append(pasteLinkRow)
        }

        let footer = customLinkRows.isEmpty ? "Add custom links for testing.".localized() : "Add custom links for testing. Tap (i) to duplicate and compose the link.".localized()
        let customLinksSection = TableViewSectionViewModel(header: "Custom Links".localized(), footer: footer, rows: rows)

        return customLinksSection
    }

    /// Sections for each AppID
    private var appSections: [TableViewSectionViewModel] {
        var sections: [TableViewSectionViewModel] = []

        self.userAASA.userApps.forEach { userAppID in
            var rows: [TableViewCellViewModel] = []

            if let app = userAppID.app,
                let icon = userAppID.icon {
                let appRow = TableViewCellViewModel(title: app.appName, image: icon, cellStyle: .default, selectAction: {
                    self.download(userAppID.appID)
                })

                rows.append(appRow)
            }

            let appIDRow = TableViewCellViewModel(title: userAppID.cellTitle, subtitle: userAppID.cellSubtitle, cellStyle: .subtitle, selectionStyle: .none, accessoryType: .none)
            rows.append(appIDRow)

            if //hasOnlyOneApp == false,
                userAppID.supportsAppLinks {
                let row = TableViewCellViewModel(title: "Universal Links".localized(), selectAction: {
                    self.showLinkViewController(userApp: userAppID)
                })
                rows.append(row)
            }

            let section = TableViewSectionViewModel(header: userAppID.appID.bundleID, footer: nil, rows: rows)
            sections.append(section)
        }

        return sections
    }

    @objc private func composeLink(_ url: URL, title: String) {
        guard let vc = ComposeLinkViewController(url: url, title: title, urlOpener: self.urlOpener) else {
            return
        }
        vc.delegate = self

        let navController = UINavigationController(rootViewController: vc)
        self.present(navController, animated: true, completion: nil)
//        self.navigationController?.show(vc, sender: self)
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
            let alertController = UIAlertController(title: "App Search Validation Tool".localized(), message: "You will need to paste the URL yourself.".localized(), preferredStyle: .alert)
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
            vc.delegate = self
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

extension DetailViewController: ComposeLinkViewControllerDelegate {
    func saveLink(_ url: URL, title: String) {
        DispatchQueue.main.async {
            if url == self.userAASA.url.deletingPathAndQuery() {
                return // Nothing to save
            } else {
                self.userAASA.customURLs[url] = title
                self.delegate?.update(self.userAASA)
                self.reloadData()
            }
        }
    }
}

extension DetailViewController: LinkViewControllerDelegate {
    func duplicateLinkAndCompose(_ url: URL) {
        if tableView.numberOfSections > 1 {
            let row = tableView.numberOfRows(inSection: 1)
            let indexPath = IndexPath(row: row - 1, section: 1)

            tableView.performUpdates({
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            }) {
                self.composeLink(url, title: "")
            }
        } else {
            composeLink(url, title: "")
        }
    }
}
