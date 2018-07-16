//
//  MulticastDelegate.swift
//  KnilKit
//
//  Created by Ethanhuang on 2018/6/26.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

// Inspired by https://gist.github.com/klemenzagar91/8c918dc20f6c8f648b6e68e6a86fa0da and http://www.gregread.com/2016/02/23/multicast-delegates-in-swift/
public struct MulticastDelegate<D> {
    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    public func add(delegate: D) {
        delegates.add(delegate as AnyObject)
    }

    public func remove(delegate: D) {
        for thisDelegate in delegates.allObjects.reversed() {
            if thisDelegate === delegate as AnyObject {
                delegates.remove(thisDelegate)
            }
        }
    }

    public func invoke(invocation: (D) -> ()) {
        for thisDelegate in delegates.allObjects.reversed() {
            invocation(thisDelegate as! D)
        }
    }
}
