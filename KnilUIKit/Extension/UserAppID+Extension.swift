//
//  UserAppID+Extension.swift
//  KnilUIKit
//
//  Created by Ethanhuang on 2018/7/17.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import UIKit
import KnilKit

extension UserApp {
    var cellTitle: String {
        return appID.bundleID
    }

    var cellSubtitle: String {
        let pairs: [(Int, String)] = [
            (1, "👥 Team ID: \(appID.teamID)"),
            (paths?.count ?? 0, "🔗 %li Universal Links"),
            (supportsWebCredentials ? 1 : 0, "🤝 Activity Continuation"),
            (supportsActivityContinuation ? 1 : 0, "🔐 Web Credentials")
        ]

        return pairs.filter ({ $0.0 > 0 }).map({ String(format: $0.1, $0.0) }).joined(separator: "\n")
    }

    func fetchAll(completion: @escaping (_ result: Result<Void>) -> Void) {
        fetchApp { (result) in
            switch result {
            case .value(let app):
                UserApp.fetchIcon(url: app.iconURL, completion: { (result) in
                    switch result {
                    case .value(let image):
                        self.icon = image
                        completion(.value(()))
                    case .error(let error):
                        completion(.error(error))
                    }
                })
            case .error(let error):
                completion(.error(error))
            }
        }
    }

    private func fetchApp(completion: @escaping (_ result: Result<iTunesApp>) -> Void) {
        if let app = self.app {
            completion(.value(app))
        } else {
            iTunesSearchAPI.searchApp(bundleID: self.appID.bundleID) { (result) in
                switch result {
                case .value(let app):
                    self.app = app
                    completion(.value(app))
                case .error(let error):
                    completion(.error(error))
                }
            }
        }
    }

    private static func fetchIcon(url: URL, completion: @escaping (_ result: Result<UIImage>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
                let icon = UIImage(data: data) {

                completion(.value(icon))
            } else {
                completion(.error(error ?? KnilKitError.noData))
            }
            }.resume()
    }
}
