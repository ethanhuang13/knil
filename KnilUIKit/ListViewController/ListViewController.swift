//
//  ListViewController.swift
//  KnilUIKit
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import KnilKit

/// AASA List
public class ListViewController: UITableViewController {
    public var urlOpener: URLOpener?

    private lazy var dataStore: UserDataStore = {
        let fileManager = FileManager.default
        let documentDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentDirectory.appendingPathComponent("knil-userdata.json")

        let dataStore = UserDataStore(fileURL: fileURL)
        dataStore.delegate = self
        return dataStore
    }()

    private lazy var viewModel: TableViewViewModel = { TableViewViewModel(tableViewController: self) }()

    public override func viewDidLoad() {
        super.viewDidLoad()

        tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 0)

        navigationController?.navigationBar.barTintColor = .barTint
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.tint]
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.tint]
        }
        navigationItem.title = "AASA".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingAASAAlertController))

        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: .UIApplicationWillResignActive, object: nil)

        reloadData()
    }

    private func reloadData() {
        DispatchQueue.main.async {
            self.viewModel.sections = [self.aasaSection]
            self.tableView.reloadData()
        }
    }

    private var aasaSection: TableViewSectionViewModel {
        let emptyRow = TableViewCellViewModel(title: "Tap here to download".localized(), subtitle: "apple-app-site-association file".localized(), cellStyle: .subtitle, selectAction: {
            self.presentAddingAASAAlertController()
        })
        let rows: [TableViewCellViewModel] = self.dataStore.list(sortedBy: .hostname).map { userAASA in
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete".localized(), handler: { (_, _) in
                self.dataStore.remove(userAASA)
                self.reloadData()
            })

            let row = TableViewCellViewModel(title: userAASA.cellTitle, subtitle: userAASA.cellSubtitle, cellStyle: .subtitle, selectionStyle: .default, editActions: [deleteAction], selectAction: {
                self.showDetailViewController(userAASA: userAASA)
            })
            return row
        }

        let section = TableViewSectionViewModel(header: nil, footer: nil, rows: rows.isEmpty ? [emptyRow] : rows)

        return section
    }

    @objc private func presentAddingAASAAlertController() {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Enter Hostname".localized(), message: "If you enter a hostname, Knil will fetch its /apple-app-site-association.\n\nOr just enter a company name like twitter, fb, or netflix.".localized(), preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "www.company.com/apple-app-site-association"
                textField.clearButtonMode = .always
                textField.keyboardType = .URL

                if #available(iOSApplicationExtension 10.0, *) {
                    textField.textContentType = .URL
                }
            }
            alertController.addAction(UIAlertAction(title: "I'm Feeling Lucky".localized(), style: .default, handler: { (_) in
                guard let string = alertController.textFields?.first?.text else {
                    fatalError("Missing textField")
                }

                AASAURLSuggestor.suggestAASA(from: string, completion: { (result) in
                    switch result {
                    case .value(let userAASA):
                        self.dataStore.upsert(userAASA)
                        self.showDetailViewController(userAASA: userAASA)
                    case .error(let error):
                        print(error.localizedDescription)
                        self.presentConfirmURLAlertController(urlString: AASAURLSuggestor.suggestURL(from: string)?.absoluteString ?? string)
                    }
                })
            }))
            alertController.addAction(.cancelAction)
            self.present(alertController, animated: true, completion: { })
        }
    }

    private func presentConfirmURLAlertController(urlString: String, suggesting userAASA: UserAASA? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Confirm or Adjust".localized(), message: "Suggested AASA URL:\n\(urlString)".localized(), preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.text = urlString
                textField.clearButtonMode = .always
                textField.keyboardType = .URL

                if #available(iOSApplicationExtension 10.0, *) {
                    textField.textContentType = .URL
                }
            }

            alertController.addAction(UIAlertAction(title: "Go".localized(), style: .default, handler: { (_) in
                guard let string = alertController.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                    fatalError("Missing textField")
                }

                if let userAASA = userAASA,
                    string == urlString {
                    self.dataStore.upsert(userAASA)
                    self.showDetailViewController(userAASA: userAASA)
                } else {
                    guard let url = URL(string: string) else {
                        self.present(UIAlertController.cancelAlertController(title: "Error".localized(), message: "URL invalid.".localized()), animated: true, completion: nil)
                        return
                    }

                    AASAFetcher.fetch(url: url, completion: { (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .value(let (aasa, redirectURL)):
                                if url.absoluteString != redirectURL.absoluteString {
                                    let message = String(format: "Redirected to %@.".localized(), redirectURL.absoluteString)

                                    let alertController = UIAlertController(title: "Redirection Occurred".localized(), message: message, preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (_) in
                                        let userAASA = UserAASA(aasa: aasa, from: url)
                                        self.dataStore.upsert(userAASA)
                                        self.dataStore.archive()
                                        self.showDetailViewController(userAASA: userAASA)
                                    }))
                                    self.present(alertController, animated: true, completion: { })
                                } else {
                                    let userAASA = UserAASA(aasa: aasa, from: url)
                                    self.dataStore.upsert(userAASA)
                                    self.dataStore.archive()
                                    self.showDetailViewController(userAASA: userAASA)
                                }

                            case .error(let error):
                                self.present(UIAlertController.cancelAlertController(title: "Error".localized(), message: error.localizedDescription), animated: true, completion: nil)
                            }
                        }
                    })
                }
            }))

            alertController.addAction(.cancelAction)
            self.present(alertController, animated: true, completion: { })
        }
    }

    private func showDetailViewController(userAASA: UserAASA) {
        DispatchQueue.main.async {
            let vc = DetailViewController(userAASA: userAASA, urlOpener: self.urlOpener)
            vc.delegate = self
            self.navigationController?.show(vc, sender: self)
        }
    }

    @objc func appWillResignActive() {
        dataStore.archive()
    }
}

extension ListViewController: UserDataStoreDelegate {
    public func aasaListDidUpdate() {
        self.reloadData()
    }
}

extension ListViewController: DetailViewControllerDelegate {
    func update(_ userAASA: UserAASA) {
        self.dataStore.upsert(userAASA)
        self.dataStore.archive()
    }
}
