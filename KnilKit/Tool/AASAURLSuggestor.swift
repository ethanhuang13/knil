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
         twitter => www.twitter.com
         facebook.com => www.facebook.com
         spotify => open.spotify
         */

        if let url = URL(string: string),
            let host = url.host {
            return host
        } else if string.caseInsensitiveCompare("spotify") == .orderedSame {
            return "open.spotify.com"
        } else if string.range(of: ".") == nil {
            return "www.\(string).com"
        } else {
            let hostname = string
                .replacingOccurrences(of: "https://", with: "", options: [.caseInsensitive, .anchored], range: nil)
                .replacingOccurrences(of: "http://", with: "", options: [.caseInsensitive, .anchored], range: nil)
                .components(separatedBy: "/").first!
            return hostname
        }
    }

    private static func aasaURL(host: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "/apple-app-site-association"
        return urlComponents.url
    }

    private static func aasaWellKnownURL(host: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = "/.well-known/apple-app-site-association"
        return urlComponents.url
    }

    public static func suggestURL(from string: String, wellKnown: Bool = false) -> URL? {
        let host = suggestHostname(from: string)

        if wellKnown {
            return aasaWellKnownURL(host: host)
        } else {
            return aasaURL(host: host)
        }
    }

    public static func suggestAASA(from string: String, completion: @escaping (_ result: Result<UserAASA>) -> Void) {
        guard let wellKnownURL = suggestURL(from: string, wellKnown: true),
            let url = suggestURL(from: string) else {
                completion(.error(KnilKitError.invalidURLString(string)))
                return
        }

        AASAFetcher.fetch(url: wellKnownURL) { (result) in
            switch result {
            case .value(let (aasa, wellKnownURL)):
                let userAASA = UserAASA(aasa: aasa, from: wellKnownURL)
                completion(.value(userAASA))
            case .error(_):
                AASAFetcher.fetch(url: url, completion: { (result) in
                    switch result {
                    case .value(let (aasa, url)):
                        let userAASA = UserAASA(aasa: aasa, from: url)
                        completion(.value(userAASA))
                    case .error(let error):
                        completion(.error(error))
                    }
                })
            }
        }
    }
}
