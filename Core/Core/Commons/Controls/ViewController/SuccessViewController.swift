//
//  SuccessViewController.swift
//  Core
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit
import RxSwift

public class SuccessViewController: UIViewController {
    public let disposeBag = DisposeBag()
    public var viewModel: SuccessViewModelProtocol!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
}

private extension SuccessViewController {
    func bindViewModel() {
        titleLabel.text = viewModel.title
        imageView.image = UIImage(named: viewModel.imageName)
    }
}

extension SuccessViewController: Themable {
    public func apply(theme: Theme) {
        titleLabel.textColor = theme.secondary
        imageView.tintColor = theme.secondary
        view.backgroundColor = theme.primaryć
    }
}

extension SuccessViewController: StoryboardMakeable {
    public typealias StoryboardMakeableType = SuccessViewController
    public static var storyboardName = "Common"
}
