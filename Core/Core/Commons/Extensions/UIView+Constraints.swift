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
        let viewsDict = ["view": self]
        self.superview?.addConstraints(NSLayoutConstraint
            .constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: viewsDict))
        self.superview?.addConstraints(NSLayoutConstraint
            .constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: viewsDict))
    }
}
