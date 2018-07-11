//
//  iTunesSearchAPI.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/11.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct iTunesSearchAPI {
    public static func searchApp(bundleID: String, completion: @escaping (Result<iTunesApp>) -> Void) {
        let urlString = "https://itunes.apple.com/lookup?bundleId=\(bundleID)"
        
        guard let url = URL(string: urlString) else {
            completion(.error(KnilKitError.invalidURLString(urlString)))
            return
        }

        url.performRequest { (result) in
            switch result {
            case .value(let data):
                do {
                    let appResults = try JSONDecoder().decode(iTunesAppResultsWrapper.self, from: data)
                    if let app = appResults.results.first {
                        completion(.value(app))
                    } else {
                        completion(.error(KnilKitError.noData))
                    }
                } catch {
                    completion(.error(error))
                }
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}

struct iTunesAppResultsWrapper: Codable {
    let results: [iTunesApp]
}
