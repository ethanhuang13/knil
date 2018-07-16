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

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingAASAAlertController))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: .UIApplicationWillResignActive, object: nil)

        reloadData()
    }

    private func reloadData() {
        DispatchQueue.main.async {
            let rows = self.dataStore.list().map { userAASA in
                return TableViewCellViewModel(title: userAASA.cellTitle, subtitle: userAASA.cellSubtitle, cellStyle: .subtitle, selectionStyle: .default, accessoryType: .disclosureIndicator, previewingViewController: nil, selectAction: {
                    self.showDetailViewController(userAASA: userAASA)
                })
            }
            let section = TableViewSectionViewModel(header: nil, footer: nil, rows: rows)
            self.viewModel.sections = [section]
            self.tableView.reloadData()
        }
    }

    @objc private func presentAddingAASAAlertController() {
        let alertController = UIAlertController(title: "Enter hostname or URL".localized(), message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "e.g. twitter.com".localized()
            textField.text = "twitter.com"
            textField.clearButtonMode = .always
            textField.keyboardType = .URL

            if #available(iOSApplicationExtension 10.0, *) {
                textField.textContentType = .URL
            }
        }
        alertController.addAction(UIAlertAction(title: "Go".localized(), style: .default, handler: { (_) in
            guard let string = alertController.textFields?.first?.text else {
                fatalError("Missing textField")
            }

            AASAURLSuggestor.suggestAASA(from: string, completion: { (result) in
                switch result {
                case .value(let userAASA):
                    self.presentConfirmURLAlertController(urlString: userAASA.url.absoluteString, suggested: userAASA)
                case .error(let error):
                    print(error.localizedDescription)
                    self.presentConfirmURLAlertController(urlString: string)
                }
            })
        }))
        alertController.addAction(.cancelAction)
        present(alertController, animated: true, completion: { })
    }

    private func presentConfirmURLAlertController(urlString: String, suggested userAASA: UserAASA? = nil) {
        let alertController = UIAlertController(title: "Confirm or Adjust".localized(), message: "Suggested AASA URL:\n\(urlString)".localized(), preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = urlString
        }

        alertController.addAction(UIAlertAction(title: "Go".localized(), style: .default, handler: { (_) in
            guard let string = alertController.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
                fatalError("Missing textField")
            }

            if let userAASA = userAASA,
                string == urlString {
                self.dataStore.add(userAASA)
                self.showDetailViewController(userAASA: userAASA)
            } else {
                guard let url = URL(string: string) else {
                    // TODO: Present alert: URL is invalid
                    return
                }

                AASAFetcher.fetch(url: url, completion: { (result) in
                    switch result {
                    case .value(let aasa):
                        DispatchQueue.main.async {
                            let userAASA = UserAASA(aasa: aasa, from: url)
                            self.dataStore.add(userAASA)
                            self.showDetailViewController(userAASA: userAASA)
                        }
                    case .error(let error):
                        print(error.localizedDescription)
                        // TODO: Present alert: AASA not found
                    }
                })
            }
        }))

        alertController.addAction(.cancelAction)

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: { })
        }
    }

    private func showDetailViewController(userAASA: UserAASA) {
        let vc = DetailViewController(userAASA: userAASA)
        vc.urlOpener = urlOpener
        navigationController?.show(vc, sender: self)
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
