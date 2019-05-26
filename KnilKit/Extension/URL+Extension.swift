//
//  URL+Extension.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/11.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

extension URL {
    func performRequest(completion: @escaping (_ result: Result<(Data, URL)>) -> Void) {
        let request = URLRequest(url: self)

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                completion(.error(KnilKitError.cannotFetchFile(self.absoluteString)))
                return
            }

            guard let data = data,
                let urlResponse = response as? HTTPURLResponse,
                urlResponse.statusCode == 200,
                let url = urlResponse.url else {
                    completion(.error(KnilKitError.noData))
                    return
            }

            completion(.value((data, url)))
            }.resume()
    }

    public func deletingPathAndQuery() -> URL? {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        urlComponents?.path = ""
        urlComponents?.queryItems = nil
        return urlComponents?.url
    }

    public var relativePathAndQuery: String {
        if let query = query {
            return relativePath + "?" + query
        } else {
            return relativePath
        }
    }
}
