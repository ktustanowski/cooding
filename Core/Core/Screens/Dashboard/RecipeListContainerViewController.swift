//
//  AllRecipesViewController.swift
//  Core
//
//  Created by Kamil Tustanowski on 29/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public final class RecipeListContainerViewController: UIViewController {
    public var viewModel: RecipeListContainerViewModelProtocol = RecipeListContainerViewModel(recipeURL: URL(string: "https://raw.githubusercontent.com/ktustanowski/cooding/master/Recipes/recipes_list.json")!,
                                                                                              downloader: Downloader())
    public var disposeBag = DisposeBag()
    
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var bottomBar: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        viewModel.input.viewDidLoad()
    }
}

private extension RecipeListContainerViewController {
    func bindViewModel() {
        viewModel.output.recipeListViewModel
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
                                                   message: "I couldn't load recipies. Sorry about that...", //TODO: Translations
                                                   isRetryAvailable: true)
        
        errorIndicator.viewModel.output.didTapRetry
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.reload()
            })
            .disposed(by: errorIndicator.disposeBag)
        
        embed(errorIndicator, in: contentContainer)
    }
    
    func embedContent(viewModel: RecipeListViewModelProtocol) {
        guard isEmbedded({ $0 is RecipeListViewController }) == false else { return }
        removeAllEmbedded()

        let content = RecipeListViewController()
        content.viewModel = viewModel
        
        content.viewModel.output.didSelectRecipe
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] recipe in
                self?.viewModel.input.selected(recipe: recipe)
            }).disposed(by: content.disposeBag)
        
        embed(content, in: contentContainer)
    }
}

extension RecipeListContainerViewController: StoryboardMakeable {
    public typealias StoryboardMakeableType = RecipeListContainerViewController
    public static var storyboardName = "Dashboard"
}
