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

extension EnumCollection where Self: Hashable {
    static var allCases: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            var first: Self?
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                if raw == 0 {
                    first = current
                } else if current == first {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
}
