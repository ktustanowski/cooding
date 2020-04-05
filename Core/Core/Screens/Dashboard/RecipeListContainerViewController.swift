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
    private var theme: Theme = ThemeFactory.make()
    public var viewModel: RecipeListContainerViewModelProtocol!
    public var disposeBag = DisposeBag()
    
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var bottomBar: UIView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        viewModel.input.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.input.viewWillAppear()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.input.viewDidAppear()
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
                guard let strongSelf = self else { return }
                self?.embedLoadingIndicator(theme: strongSelf.theme,
                                            in: strongSelf.contentContainer)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.needsRecipesURL
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.askForRecipeListURL()
            }
            .disposed(by: disposeBag)
    }
    
    func embedErrorIndicator() {
        guard isEmbedded({ $0 is NoDataViewController }) == false else { return }
        removeAllEmbedded()

        let errorIndicator = NoDataViewController.make()
        errorIndicator.viewModel = .cantLoadRecipes
        errorIndicator.apply(theme: theme)

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
        content.apply(theme: theme)
        
        content.viewModel.output.didSelectRecipe
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] recipe in
                self?.viewModel.input.selected(recipe: recipe)
            }).disposed(by: content.disposeBag)
        
        embed(content, in: contentContainer)
    }
    
    func presentEnterRecipeURLAlert(onInput: @escaping ((URL?) -> Void)) {
        let alert = UIAlertController(title: "recipe.list.screen.url.alert.title".localized,
                                      message: "recipe.list.screen.url.alert.message".localized,
                                      preferredStyle: .alert)
        alert.view.tintColor = theme.action
        let action = UIAlertAction(title: "done".localized, style: .default) { _ in
            let urlString = alert.textFields?.first?.text ?? ""
            onInput(URL(string: urlString))
        }
        
        alert.addTextField { textField in
            textField.placeholder = "recipe.list.screen.url.alert.text.placeholder".localized
        }
                
        let dismiss = UIAlertAction(title: "close".localized, style: .cancel) { _ in
            onInput(URL(string: "no-url"))
        }

        alert.addAction(action)
        alert.addAction(dismiss)
        
        present(alert, animated: true, completion: nil)
    }
}

extension RecipeListContainerViewController: Themable {
    public func apply(theme: Theme = ThemeFactory.make()) {
        self.theme = theme
        view.backgroundColor = theme.primary
        contentContainer.backgroundColor = theme.primary
    }
}

extension RecipeListContainerViewController: StoryboardMakeable {
    public typealias StoryboardMakeableType = RecipeListContainerViewController
    public static var storyboardName = "Dashboard"
}
