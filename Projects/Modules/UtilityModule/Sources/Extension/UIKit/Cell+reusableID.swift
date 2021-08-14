//
//  Cell+reusableID.swift
//  UtilityModule
//
//  Created by 한상진 on 2021/07/07.
//  Copyright © 2021 softbay. All rights reserved.
//

import UIKit

public protocol ReuseIdentifiable {
    static var reusableID: String { get }
}

public extension ReuseIdentifiable {
    static var reusableID: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifiable {}
extension UICollectionReusableView: ReuseIdentifiable {}
