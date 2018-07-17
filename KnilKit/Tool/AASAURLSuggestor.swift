//
//  AASAURLSuggestor.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/15.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct AASAURLSuggestor {
    private static func suggestHostname(from string: String) -> String {
        /*
         twitter => twitter.com
         facebook.com => facebook.com
         */

        if let url = URL(string: string),
            let host = url.host {
            return host
        } else if string.range(of: ".") == nil {
            return "www.\(string).com"
        } else {
            return string
        }
    }

    private static func suggestURL(hostname: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = hostname
        urlComponents.path = "/apple-app-site-association"
        return urlComponents.url
    }

    public static func suggestAASA(from string: String, completion: @escaping (_ result: Result<UserAASA>) -> Void) {
        let hostname = suggestHostname(from: string)

        guard let url = suggestURL(hostname: hostname) else {
            completion(.error(KnilKitError.invalidURLString(hostname)))
            return
        }

        AASAFetcher.fetch(url: url) { (result) in
            switch result {
            case .value(let aasa):
                let userAASA = UserAASA(aasa: aasa, from: url)
                completion(.value(userAASA))
            case .error(let error):
                completion(.error(error))
            }
        }
    }

    public static func suggestURLString(from string: String) -> String {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = suggestHostname(from: string)
        urlComponents.path = "/apple-app-site-association"
        return urlComponents.url?.absoluteString ?? string
    }
}
