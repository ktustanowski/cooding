//
//  EmptyViewController.swift
//  Core
//
//  Created by Kamil Tustanowski on 30/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public final class NoDataViewController: UIViewController {
    public var viewModel: NoDataViewModel!
    var disposeBag = DisposeBag()
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var retryLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
}

private extension NoDataViewController {
    func bindViewModel() {
        viewModel.output.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.message
            .bind(to: messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.isRetryAvailable
            .bind(to: retryButton.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        viewModel.output.isRetryAvailable
            .map { !$0 }
            .bind(to: retryLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        retryButton.rx
            .controlEvent(.touchUpInside)
            .subscribe { [weak self] _ in
                self?.viewModel.input.retryTapped()
            }
            .disposed(by: disposeBag)
    }
}

extension NoDataViewController: StoryboardMakeable {
    public typealias StoryboardMakeableType = NoDataViewController
    public static var storyboardName = "Common"
}
