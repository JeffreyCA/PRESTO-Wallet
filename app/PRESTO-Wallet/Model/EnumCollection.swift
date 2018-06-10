//
//  EnumCollection.swift
//  PRESTO-Wallet
//
//  Created by Jeffrey on 2018-01-07.
//  Copyright © 2018 JeffreyCA. All rights reserved.
//
//  From this StackOverflow post: https://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type/32429125#32429125
//

protocol EnumCollection: Hashable {}

extension EnumCollection {
    static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
}
