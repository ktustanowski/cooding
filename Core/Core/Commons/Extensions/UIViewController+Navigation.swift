//
//  UIViewController+Navigation.swift
//  Core
//
//  Created by Kamil Tustanowski on 03/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    func replaceBackButtonWithBackArrow(theme: Theme = DefaultTheme()) {
        let backArrow = UIBarButtonItem(image: UIImage(named: "backArrow"),
                                        style: .plain,
                                        target: nil,
                                        action: nil)
        backArrow.tintColor = theme.action
        backArrow.tag = 92817
        navigationItem.leftBarButtonItem = backArrow
    }
    
    var onDismiss: Observable<Void>? {
        return backArrow?
            .rx
            .tap
            .asObservable()
    }
    
    private var backArrow: UIBarButtonItem? {
        guard let backArrow = navigationItem.leftBarButtonItem, backArrow.tag == 92817 else { return nil }
        
        return backArrow
    }
}
