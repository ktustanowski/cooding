//
//  UIView+RoundCorners.swift
//  Core
//
//  Created by Kamil Tustanowski on 30/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public extension UIView {
    func roundCorners(radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }
}
