//
//  Optional+Utility.swift
//  UtilityModule
//
//  Created by 한상진 on 2021/07/01.
//  Copyright © 2021 softbay. All rights reserved.
//

import Foundation

public extension Optional {
    var isNil: Bool {
        return self == nil
    }

    var isNotNil: Bool {
        return self != nil
    }
}
