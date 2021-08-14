//
//  Array+safe.swift
//  UtilityModule
//
//  Created by 한상진 on 2021/07/21.
//  Copyright © 2021 softbay. All rights reserved.
//

import Foundation

public extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
