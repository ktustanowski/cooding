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
    public var viewModel: RecipeListContainerViewModelProtocol!
    public var disposeBag = DisposeBag()
    
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var bottomBar: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        viewModel.input.viewDidLoad()
        contentContainer.backgroundColor = .orange
    }
}

private extension RecipeListContainerViewController {
    func bindViewModel() {
        viewModel.output.recipeListViewModel
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] viewModel in
                if let viewModel = viewModel {
                    self?.embedContent(viewModel: viewModel)
                } else {
                    self?.embedErrorIndicator()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .observeOn(MainScheduler.instance)
            .filter { $0 == true }
            .subscribe { [weak self]_ in
                self?.embedLoadingIndicator()
            }
            .disposed(by: disposeBag)
        
        viewModel.output.hasRecipeListURL
            .observeOn(MainScheduler.instance)
            .filter { $0 == false }
            .subscribe { [weak self] _ in
                self?.askForRecipeListURL()
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
        
        Observable.combineLatest(errorIndicator.viewModel.output.didTapRetry,
                                 viewModel.output.hasRecipeListURL)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _, hasRecipeListURL in
                if hasRecipeListURL {
                    self?.viewModel.reload()
                } else {
                    self?.askForRecipeListURL()
                }
            })
            .disposed(by: errorIndicator.disposeBag)
        
        embed(errorIndicator, in: contentContainer)
    }
    
    func askForRecipeListURL() {
        presentEnterRecipeURLAlert(onInput: { [weak self] url in
            self?.viewModel.input.recipeList(url: url)
        })
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
    
    func presentEnterRecipeURLAlert(onInput: @escaping ((URL?) -> Void)) {
        let alert = UIAlertController(title: "Hello there!", //TODO: Translations
                                      message: "Please input your own recipe list repository URL", //TODO: Translations
                                      preferredStyle: .alert) //TODO: Translations
        
        let action = UIAlertAction(title: "Done", style: .default) { _ in //TODO: Translations
            let urlString = alert.textFields?.first?.text ?? ""
            onInput(URL(string: urlString))
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Your recipe repository URL" //TODO: Translations
        }
        
        let dismiss = UIAlertAction(title: "Close", style: .cancel, handler: nil) //TODO: Translations
        
        alert.addAction(action)
        alert.addAction(dismiss)
        
        present(alert, animated: true, completion: nil)
    }
}

extension RecipeListContainerViewController: StoryboardMakeable {
    public typealias StoryboardMakeableType = RecipeListContainerViewController
    public static var storyboardName = "Dashboard"
}
