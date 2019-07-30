//
//  UIViewController+Embedding.swift
//  Core
//
//  Created by Kamil Tustanowski on 29/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit

public extension UIViewController {
    func embed(_ viewController: UIViewController) {
        embed(viewController, in: view)
    }
    
    func embed(_ viewController: UIViewController, in containerView: UIView) {
        addChild(viewController)
        viewController.view.frame = containerView.frame
        containerView.addSubview(viewController.view)
        viewController.view.fillInSuperview()
        viewController.didMove(toParent: self)
    }
    
    func removeEmbedded(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    func removeAllEmbedded() {
        children.forEach { [weak self] child in
            self?.removeEmbedded(child)
        }
    }
    
    func isEmbedded(_ comparator: (UIViewController) -> Bool) -> Bool {
        return children.filter(comparator).isEmpty == false
    }
}
