//
//  RecipeContainerViewController.swift
//  Core
//
//  Created by Kamil Tustanowski on 31/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift

public final class RecipeContainerViewController: UIViewController {
    public var viewModel: RecipeContainerViewModelProtocol!
    private let contentContainer = UIView(frame: .zero)
    public let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    
        setupContainer()
        bindViewModel()
        viewModel.input.viewDidLoad()
        //TODO: Clean this up later
        let cookingButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(cookingButtonTapped))
        navigationItem.rightBarButtonItem = cookingButton
    }
}

private extension RecipeContainerViewController {
    @objc
    func cookingButtonTapped() {
        viewModel.input.startCookingTapped()
    }
    
    func setupContainer() {
        view.addSubview(contentContainer)
        contentContainer.fillInSuperview()
    }

    func bindViewModel() {
        viewModel.output.recipeViewModel
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewModel in
                self?.embedContent(viewModel: viewModel)
                }, onError: { [weak self] _ in
                    self?.embedErrorIndicator()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .observeOn(MainScheduler.instance)
            .filter { $0 == true }
            .subscribe { [weak self]_ in
                self?.embedLoadingIndicator()
            }
            .disposed(by: disposeBag)
    }
    
    func embedLoadingIndicator() {
        guard isEmbedded({ $0 is ProgressIndicatorViewController }) == false else { return }
        removeAllEmbedded()
        
        let progressIndicator = ProgressIndicatorViewController.make()
        
        embed(progressIndicator, in: contentContainer)
    }
    
    func embedErrorIndicator() {
        guard isEmbedded({ $0 is NoDataViewController }) == false else { return }
        removeAllEmbedded()
        
        let errorIndicator = NoDataViewController.make()
        errorIndicator.viewModel = NoDataViewModel(title: "Uh oh!", //TODO: Translations
            message: "I couldn't load recipe. Sorry about that...", //TODO: Translations
            isRetryAvailable: true)
        
        errorIndicator.viewModel.output.didTapRetry
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.reload()
            })
            .disposed(by: errorIndicator.disposeBag)
        
        embed(errorIndicator, in: contentContainer)
    }
    
    func embedContent(viewModel: RecipeViewModelProtocol) {
        guard isEmbedded({ $0 is RecipeViewController }) == false else { return }
        removeAllEmbedded()
        
        let content = RecipeViewController()
        content.viewModel = viewModel
        
        embed(content, in: contentContainer)
    }
}
