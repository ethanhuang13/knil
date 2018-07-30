//
//  TabBarController.swift
//  Knil
//
//  Created by Ethanhuang on 2018/7/30.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import KnilUIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setNeedsStatusBarAppearanceUpdate()

        tabBar.barTintColor = .barTint

        let listVC = ListViewController(style: .plain)
        listVC.urlOpener = UIApplication.shared.delegate as? AppDelegate

        let vcs = [
            UINavigationController(rootViewController: listVC),
            UINavigationController(rootViewController: SettingsViewController(style: .grouped))]

        viewControllers = vcs

        vcs.forEach({ (vc) in
            _ = vc.viewControllers.first?.view.description // Preload each view controllers
        })
    }
}
