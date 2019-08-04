//
//  UIViewControler+Embeddable.swift
//  Core
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift

extension UIViewController {
    func embedErrorIndicator(viewModel: NoDataViewModel,
                             theme: Theme,
                             retryAction: (() -> Void)?,
                             in container: UIView) {
        guard isEmbedded({ $0 is NoDataViewController }) == false else { return }
        removeAllEmbedded()
        
        let errorIndicator = NoDataViewController.make()
        errorIndicator.viewModel = viewModel
        errorIndicator.apply(theme: theme)
        
        errorIndicator.viewModel.output.didTapRetry
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                retryAction?()
            })
            .disposed(by: errorIndicator.disposeBag)
        
        embed(errorIndicator, in: container)
    }
    
    func embedLoadingIndicator(theme: Theme,
                               in container: UIView) {
        guard isEmbedded({ $0 is ProgressIndicatorViewController }) == false else { return }
        removeAllEmbedded()
        
        let progressIndicator = ProgressIndicatorViewController.make()
        progressIndicator.apply(theme: theme)
        
        embed(progressIndicator, in: container)
    }
}
