//
//  UIView+Shrink.swift
//  Core
//
//  Created by Kamil Tustanowski on 03/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

extension UIView {
    func shrink(down: Bool,
                duration: TimeInterval = 0.2,
                scaleX: CGFloat = 0.95,
                scaleY: CGFloat = 0.95) {
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: [.allowUserInteraction],
                       animations: {
                           if down {
                               self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                           } else {
                               self.transform = .identity
                           }
                       }, completion: nil)
    }
}
