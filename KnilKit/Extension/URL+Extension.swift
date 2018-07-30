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
            if let error = error {
                completion(.error(error))
                return
            }

            guard let data = data,
                let url = (response as? HTTPURLResponse)?.url else {
                completion(.error(KnilKitError.noData))
                return
            }

            completion(.value((data, url)))
            }.resume()
    }
}
