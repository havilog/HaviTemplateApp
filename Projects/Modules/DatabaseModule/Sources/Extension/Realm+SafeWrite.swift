//
//  Realm+SafeWrite.swift
//  DatabaseModule
//
//  Created by 한상진 on 2021/07/05.
//  Copyright © 2021 softbay. All rights reserved.
//

import Foundation
import ThirdPartyManager

import RealmSwift

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
