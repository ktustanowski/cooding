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
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        progressBackgroundView.roundCorners(radius: progressBackgroundView.frame.size.height / 2)
    }
}

extension ProgressIndicatorViewController: StoryboardMakeable {
    public typealias StoryboardMakeableType = ProgressIndicatorViewController
    public static var storyboardName = "Common"
}
