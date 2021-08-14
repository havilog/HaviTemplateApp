//
//  Snapkit+Safe.swift
//  Features
//
//  Created by 한상진 on 2021/07/07.
//  Copyright © 2021 softbay. All rights reserved.
//

import UIKit
import ThirdPartyManager

import SnapKit

extension UIView {
    var safeArea: ConstraintLayoutGuideDSL {
        return safeAreaLayoutGuide.snp
    }
}
