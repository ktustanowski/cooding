//
//  DashboardTabBarController.swift
//  Core
//
//  Created by Kamil Tustanowski on 29/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit
import RxSwift

public final class DashboardTabBarController: UITabBarController {
    private var theme: Theme = ThemeFactory.make()
    public var viewModel: DashboardViewModelProtocol!
    private(set) var disposeBag = DisposeBag()
    
    public init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, viewModel: DashboardViewModelProtocol = DashboardViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension DashboardTabBarController {
    func setup() {
        hidesBottomBarWhenPushed = true
        
        viewControllers = [makeAllRecipes(),
                           makeMyRecipes()]
    }
    
    func makeAllRecipes() -> UIViewController {
        return makeRecipeViewController(viewModel: viewModel.output.allRecipiesViewModel,
                                        buttonTitle: viewModel.output.allRecipiesButtonTitle)
    }
    
    func makeMyRecipes() -> UIViewController {
        return makeRecipeViewController(viewModel: viewModel.output.myRecipiesViewModel,
                                        buttonTitle: viewModel.output.myRecipiesButtonTitle)
    }
    
    func makeRecipeViewController(viewModel: RecipeListContainerViewModelProtocol,
                                  buttonTitle: String) -> RecipeListContainerViewController {
        let viewController = RecipeListContainerViewController.make()
        viewController.viewModel = viewModel
        viewController.apply(theme: theme)
        
        viewController.viewModel.output.didSelectRecipe
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] recipe in
                self?.viewModel.input.selected(recipe: recipe)
            })
            .disposed(by: viewController.disposeBag)
        
        viewController.tabBarItem = UITabBarItem(title: buttonTitle,
                                                 image: UIImage(named: "dish"),
                                                 selectedImage: nil)
        return viewController
    }
}

extension DashboardTabBarController: Themable {
    public func apply(theme: Theme = ThemeFactory.make()) {
        self.theme = theme
        tabBar.tintColor = theme.action
    }
}
