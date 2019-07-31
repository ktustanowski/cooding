//
//  UIView+Constraints.swift
//  Core
//
//  Created by Kamil Tustanowski on 29/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit

public extension UIView {
    func fillInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        superview?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        superview?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        superview?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
