//
//  ProgressIndicatorViewController.swift
//  Core
//
//  Created by Kamil Tustanowski on 29/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit

public final class ProgressIndicatorViewController: UIViewController {
    @IBOutlet private weak var progressBackgroundView: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBackgroundView.roundCorners(radius: Constants.ui.cornerRadius)
    }
}

extension ProgressIndicatorViewController: StoryboardMakeable {
    public typealias StoryboardMakeableType = ProgressIndicatorViewController
    public static var storyboardName = "Common"
}

extension ProgressIndicatorViewController: Themable {
    public func apply(theme: Theme = ThemeFactory.make()) {
        view.backgroundColor = theme.primary
        progressBackgroundView.backgroundColor = theme.auxiliary
    }
}
