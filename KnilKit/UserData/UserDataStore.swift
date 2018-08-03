//
//  UserDataStore.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/7/16.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public typealias Hostname = String

public enum AASASortOption {
    case hostname
    case fetchedDate
}

public protocol UserDataStoreDelegate {
    func aasaListDidUpdate()
}

public class UserDataStore {
    public init(fileURL: URL) {
        self.fileURL = fileURL
        unarchive()
    }

    public private(set) var userAASAs: [Hostname: UserAASA] = [:] {
        didSet {
            notifyDidUpdate()
        }
    }

    public var delegate: UserDataStoreDelegate?

    private var fileURL: URL

    public func unarchive() {
        do {
            userAASAs = try UserDataStore.load(from: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }

    public func archive() {
        do {
            try UserDataStore.save(userAASAs, to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
    }

    public func upsert(_ userAASA: UserAASA) -> UserAASA {
        if let existUserAASA = userAASAs[userAASA.hostname] {
            existUserAASA.update(userAASA.aasa)
            notifyDidUpdate()
            return existUserAASA
        } else {
            userAASAs[userAASA.hostname] = userAASA
            return userAASA
        }
    }

    public func remove(_ userAASA: UserAASA) {
        userAASAs[userAASA.hostname] = nil
    }

    public func list(sortedBy option: AASASortOption) -> [UserAASA] {
        switch option {
        case .hostname:
            return userAASAs.values.sorted {
                $0.hostname < $1.hostname
            }
        case .fetchedDate:
            return userAASAs.values.sorted {
                $0.fetchedDate < $1.fetchedDate
            }
        }
    }

    static func load(from fileURL: URL) throws -> [Hostname: UserAASA] {
        do {
            let userAASAs = try JSONDecoder().decode([Hostname: UserAASA].self, from: try Data(contentsOf: fileURL))
            print("Loaded \(userAASAs.count) UserAASAs")
            return userAASAs
        } catch {
            throw error
        }
    }

    static func save(_ userAASAs: [Hostname: UserAASA], to fileURL: URL) throws {
        do {
            try JSONEncoder().encode(userAASAs).write(to: fileURL)
            print("Saved \(userAASAs.count) UserAASAs")
        } catch {
            throw error
        }
    }

    private func notifyDidUpdate() {
        DispatchQueue.main.async {
            self.delegate?.aasaListDidUpdate()
        }
    }
}
