//
//  UIView+Constraints.swift
//  Core
//
//  Created by Kamil Tustanowski on 29/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit

public extension UIView {
    func fillInSuperview(margins: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.topAnchor.constraint(equalTo: topAnchor, constant: margins.top).isActive = true
        superview?.bottomAnchor.constraint(equalTo: bottomAnchor, constant: margins.bottom).isActive = true
        superview?.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margins.left).isActive = true
        superview?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: margins.right).isActive = true
    }
}
