//
//  ListViewController.swift
//  KnilUIKit
//
//  Created by Ethanhuang on 2018/7/10.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

public class ListViewController: UITableViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentAddingAlertController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: nil, action: nil)
    }

    @objc func presentAddingAlertController() {
        let urlString = "https://twitter.com/apple-app-site-association"

        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                let contentType = response.allHeaderFields["Content-Type"] {
                print(contentType)
            }

            guard let data = data,
            let string = String(data: data, encoding: .utf8) else {
                return
            }
            print(string)
        }.resume()
    }

    func presentDetailViewController() {
        let vc = DetailViewController()
        present(vc, animated: true, completion: nil)
    }
}
