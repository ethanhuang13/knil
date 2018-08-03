//
//  ComposeViewController.swift
//  KnilUIKit
//
//  Created by Ethanhuang on 2018/7/31.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import KnilKit

protocol ComposeLinkViewControllerDelegate: class {
    func saveLink(_ url: URL, title: String)
}

/// Compose a link
class ComposeLinkViewController: UITableViewController {
    public var urlOpener: URLOpener?
    internal weak var delegate: ComposeLinkViewControllerDelegate?
    private lazy var viewModel: TableViewViewModel = { TableViewViewModel(tableViewController: self) }()
    private var urlComponents: URLComponents
    private var linkTitle: String

    init?(url: URL, title: String, urlOpener: URLOpener?) {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }

        self.urlComponents = urlComponents
        self.linkTitle = title
        self.urlOpener = urlOpener
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

        navigationItem.title = "Compose Link".localized()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelComposing))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveLink))

        reloadData()
    }

    @objc private func cancelComposing() {
        self.dismiss(animated: true, completion: {})
    }

    @objc private func saveLink() {
        guard let url = urlComponents.url else {
            return
        }
        self.delegate?.saveLink(url, title: self.linkTitle)
        self.dismiss(animated: true, completion: {})
    }

    private func reloadData() {
        DispatchQueue.main.async {
            self.viewModel.sections = [
                self.urlSection,
                self.pathSection,
                self.querySection
            ]
            self.tableView.reloadData()
        }
    }

    // Display the Full URL
    private var urlSection: TableViewSectionViewModel {
        let title = linkTitle.isEmpty ? "(Untitled)".localized() : linkTitle
        let titleRow = TableViewCellViewModel(title: title, selectAction: {
            let alertController = UIAlertController(title: "Edit Link Title".localized(), message: "You can name this link.".localized(), preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { (textField) in
                textField.clearButtonMode = .always
                textField.autocapitalizationType = .words
            })
            alertController.addAction(UIAlertAction(title: "Save".localized(), style: .default, handler: { (_) in
                guard let title = alertController.textFields?.first?.text else {
                    return
                }

                self.linkTitle = title
                self.reloadData()
            }))
            alertController.addAction(.cancelAction)

            self.present(alertController, animated: true, completion: { })
        })

        let urlRow = TableViewCellViewModel(title: self.urlComponents.urlString, selectAction: {
            guard let url = self.urlComponents.url else {
                return
            }
            _ = self.urlOpener?.openURL(url)
        })
        let urlSection = TableViewSectionViewModel(header: nil, footer: "Tap the link to test. Edit path and query below.".localized(), rows: [titleRow, urlRow])
        return urlSection
    }

    // Compose Path
    private var pathSection: TableViewSectionViewModel {
        var pathRows: [TableViewCellViewModel] = []

        for (index, pathString) in self.urlComponents.pathComponents.enumerated() {
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete".localized(), handler: { (_, _) in
                self.deletePathComponent(index: index)
            })

            let pathRow = TableViewCellViewModel(title: "/" + pathString, editActions: [deleteAction], selectAction: {
                self.editPathComponent(index: index)
            })
            pathRows.append(pathRow)
        }

        let addPathRow = TableViewCellViewModel(title: "+ Append Path Components".localized(), selectAction: {
            self.appendPathComponents()
        })
        pathRows.append(addPathRow)

        let pathSection = TableViewSectionViewModel(header: "Path".localized(), footer: nil, rows: pathRows)
        return pathSection
    }

    /// Compose Query
    private var querySection: TableViewSectionViewModel {
        var queryRows: [TableViewCellViewModel] = []
        for (index, queryItem) in (self.urlComponents.queryItems ?? []).enumerated() {
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete".localized(), handler: { (_, _) in
                self.deleteQuery(index: index)
            })

            let queryRow = TableViewCellViewModel(title: "\(queryItem.name)=\(queryItem.value ?? "")", editActions: [deleteAction], selectAction: {
                self.editQuery(index: index)
            })
            queryRows.append(queryRow)
        }

        let addQueryRow = TableViewCellViewModel(title: "+ Add Query".localized(), cellStyle: .default, selectAction: {
            self.addQuery()
        })
        queryRows.append(addQueryRow)

        let querySection = TableViewSectionViewModel(header: "Query".localized(), footer: nil, rows: queryRows)
        return querySection
    }

    private func appendPathComponents() {
        let alertController = UIAlertController(title: "Append Path Components".localized(), message: "You can type the whole path once. The string will be percent-encoded.".localized(), preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "some/path/to/go"
            textField.clearButtonMode = .always
            textField.keyboardType = .URL

            if #available(iOSApplicationExtension 10.0, *) {
                textField.textContentType = .URL
            }
        })
        alertController.addAction(UIAlertAction(title: "Add".localized(), style: .default, handler: { (_) in
            guard let pathString = alertController.textFields?.first?.text?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
                return
            }

            self.urlComponents.pathComponents.append(pathString)
            self.reloadData()
        }))
        alertController.addAction(.cancelAction)

        self.present(alertController, animated: true, completion: { })
    }

    private func editPathComponent(index: Int) {
        let alertController = UIAlertController(title: "Edit Path Component".localized(), message: "The string will be percent-encoded.".localized(), preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            let text = self.urlComponents.pathComponents[index]
            textField.text = text
            textField.placeholder = text + "/then"
            textField.clearButtonMode = .always
            textField.keyboardType = .URL

            if #available(iOSApplicationExtension 10.0, *) {
                textField.textContentType = .URL
            }
        })
        alertController.addAction(UIAlertAction(title: "Save".localized(), style: .default, handler: { (_) in
            guard let pathString = alertController.textFields?.first?.text?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
                return
            }

            self.urlComponents.pathComponents[index] = pathString
            self.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Delete".localized(), style: .destructive, handler: { (_) in
            self.deletePathComponent(index: index)
        }))
        alertController.addAction(.cancelAction)

        self.present(alertController, animated: true, completion: { })
    }

    private func deletePathComponent(index: Int) {
        self.urlComponents.pathComponents.remove(at: index)
        self.reloadData()
    }

    private func addQuery() {
        let alertController = UIAlertController(title: "Add Query".localized(), message: "The string will be percent-encoded.".localized(), preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "name"
            textField.clearButtonMode = .always
        })
        alertController.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "value"
            textField.clearButtonMode = .always
        })
        alertController.addAction(UIAlertAction(title: "Add".localized(), style: .default, handler: { (_) in
            guard let textFields = alertController.textFields,
                textFields.count > 1,
                let keyString = textFields[0].text,
                let valueString = textFields[1].text else {
                    return
            }

            var queryItems = self.urlComponents.queryItems ?? []
            queryItems.append(URLQueryItem(name: keyString, value: valueString))
            self.urlComponents.queryItems = queryItems
            self.reloadData()
        }))
        alertController.addAction(.cancelAction)

        self.present(alertController, animated: true, completion: { })
    }

    private func editQuery(index: Int) {
        guard let queryItems = self.urlComponents.queryItems,
            queryItems.count > index else {
                return
        }
        let queryItem = queryItems[index]

        let alertController = UIAlertController(title: "Edit Query".localized(), message: "The strings will be percent-encoded.".localized(), preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { (textField) in
            textField.text = queryItem.name
            textField.placeholder = "name"
            textField.clearButtonMode = .always
        })
        alertController.addTextField(configurationHandler: { (textField) in
            textField.text = queryItem.value
            textField.placeholder = "value"
            textField.clearButtonMode = .always
        })
        alertController.addAction(UIAlertAction(title: "Save".localized(), style: .default, handler: { (_) in
            guard let textFields = alertController.textFields,
                textFields.count > 1,
                let keyString = textFields[0].text,
                let valueString = textFields[1].text else {
                    return
            }

            guard var queryItems = self.urlComponents.queryItems,
                queryItems.count > index else {
                    return
            }

            queryItems[index] = URLQueryItem(name: keyString, value: valueString)
            self.urlComponents.queryItems = queryItems
            self.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "Delete".localized(), style: .destructive, handler: { (_) in
            self.deleteQuery(index: index)
        }))
        alertController.addAction(.cancelAction)

        self.present(alertController, animated: true, completion: { })
    }

    private func deleteQuery(index: Int) {
        self.urlComponents.queryItems?.remove(at: index)

        if self.urlComponents.queryItems?.isEmpty == true {
            self.urlComponents.queryItems = nil
        }

        self.reloadData()
    }
}
