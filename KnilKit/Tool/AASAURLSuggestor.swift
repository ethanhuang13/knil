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

    public static func suggestURL(from string: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = suggestHostname(from: string)
        urlComponents.path = "/apple-app-site-association"
        return urlComponents.url
    }

    public static func suggestAASA(from string: String, completion: @escaping (_ result: Result<UserAASA>) -> Void) {
        guard let url = suggestURL(from: string) else {
            completion(.error(KnilKitError.invalidURLString(string)))
            return
        }

        AASAFetcher.fetch(url: url) { (result) in
            switch result {
            case .value(let (aasa, url)):
                let userAASA = UserAASA(aasa: aasa, from: url)
                completion(.value(userAASA))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
}
