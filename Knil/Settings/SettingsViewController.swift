//
//  SettingsViewController.swift
//  Knil
//
//  Created by Ethanhuang on 2018/7/30.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import KnilUIKit

class SettingsViewController: UITableViewController {
    lazy var tableViewViewModel: TableViewViewModel = { TableViewViewModel(tableViewController: self) }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 0)

        tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 0)

        navigationController?.navigationBar.barTintColor = .barTint
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.tint]
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.tint]
        }
        navigationItem.title = "About".localized()

        tableView.dataSource = tableViewViewModel
        tableView.delegate = tableViewViewModel

        reloadData()
    }

    func reloadData() {
        DispatchQueue.main.async {
            self.tableViewViewModel.sections = [
//                    self.linksSection,
//                 self.viewSection,
//                 self.dataSection,
                 self.aboutSection
            ]
            self.tableView.reloadData()
        }
    }

    private var aboutSection: TableViewSectionViewModel {
        let rateCellViewModel = TableViewCellViewModel(title: "App Store".localized(), selectAction: {
            UIApplication.shared.openURL(AppConstants.appStoreURL)
        })

        let feedbackCellViewModel = TableViewCellViewModel(title: "Feedback".localized(), selectAction: {
            self.presentFeedbackMailComposer()
        })

        let developerCellViewModel = TableViewCellViewModel(title: "Developer".localized(), subtitle: "@ethanhuang13", cellStyle: .value1, selectAction: {
            UIApplication.shared.openURL(AppConstants.developerURL)
        })

        let githubCellViewModel = TableViewCellViewModel(title: "GitHub".localized(), selectAction: {
            UIApplication.shared.openURL(AppConstants.githubURL)
        })

        let sectionViewModel = TableViewSectionViewModel(header: "About".localized(), footer: AppConstants.aboutString, rows: [rateCellViewModel, feedbackCellViewModel, developerCellViewModel, githubCellViewModel])
        return sectionViewModel
    }
}
