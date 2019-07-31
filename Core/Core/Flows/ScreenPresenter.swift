//
//  ScreenPresenter.swift
//  Core
//
//  Created by Kamil Tustanowski on 30/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public protocol ScreenPresenter: AnyObject {
    var presentedViewController: UIViewController? { get }
    var viewControllers: [UIViewController] { get set }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    
    @discardableResult func popViewController(animated: Bool) -> UIViewController?
    @discardableResult func popToRootViewController(animated: Bool) -> [UIViewController]?
    
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

extension UINavigationController: ScreenPresenter {}
