//
//  AASAFetcher.swift
//  Knil
//
//  Created by Ethanhuang on 2018/6/25.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct AASAFetcher {

    /// Will return AASA and Redirected(if occurred) URL
    public static func fetch(url: URL, completion: @escaping (Result<(AASA, URL)>) -> Void) {
        url.performRequest { (result) in
            switch result {
            case .value(let (data, url)):
                do {
                    let aasa = try AASA(data: data)
                    completion(.value((aasa, url)))
                } catch {
                    completion(.error(error))
                }
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
