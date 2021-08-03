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
    private var theme: Theme = ThemeFactory.make()

    public var viewModel: RecipeContainerViewModelProtocol!
    private let contentContainer = UIView(frame: .zero)
    public let disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    
        setupNavigationBar()
        setupContainer()
        bindViewModel()
        viewModel.input.viewDidLoad()
    }
}

private extension RecipeContainerViewController {
    func setupNavigationBar() {
        title = viewModel.output.title
        replaceBackButtonWithBackArrow(theme: theme)
        
        onDismiss?
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.input.dismiss()
            })
            .disposed(by: disposeBag)
    }
    
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
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewModel in
                guard let strongSelf = self else { return }
                if let viewModel = viewModel {
                    self?.embedContent(viewModel: viewModel)
                } else {
                    self?.embedErrorIndicator(viewModel: .cantLoadRecipe,
                                              theme: strongSelf.theme,
                                              retryAction: { strongSelf.viewModel.reload() },
                                              in: strongSelf.contentContainer)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .observe(on: MainScheduler.instance)
            .filter { $0 == true }
            .subscribe { [weak self] _ in
                guard let strongSelf = self else { return }
                self?.embedLoadingIndicator(theme: strongSelf.theme,
                                            in: strongSelf.contentContainer)
            }
            .disposed(by: disposeBag)
    }
        
    func embedContent(viewModel: RecipeViewModelProtocol) {
        guard isEmbedded({ $0 is RecipeViewController }) == false else { return }
        removeAllEmbedded()
        
        let content = RecipeViewController()
        content.viewModel = viewModel
        content.apply(theme: theme)
        
        content.viewModel.output.didTapStartCooking.subscribe { [weak self] _ in
            self?.viewModel.input.startCookingTapped()
        }
        .disposed(by: content.disposeBag)
        
        embed(content, in: contentContainer)
    }
}

extension RecipeContainerViewController: Themable {
    public func apply(theme: Theme = ThemeFactory.make()) {
        self.theme = theme
        view.backgroundColor = theme.primary
    }
}
