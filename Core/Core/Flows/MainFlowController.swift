//
//  MainFlowController.swift
//  Core
//
//  Created by Kamil Tustanowski on 30/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift

public protocol ScreenMakeable {
    func makeDashboardScreen() -> DashboardTabBarController
    func makeRecipeScreen(shortRecipe: ShortRecipe) -> RecipeContainerViewController
    func makeCookingScreen(algorithm: Algorithm) -> CookingViewController
    func makeSuccessScreen() -> SuccessViewController
}

public struct ScreenMaker: ScreenMakeable {
    public func makeDashboardScreen() -> DashboardTabBarController {
        let dashboardScreen = DashboardTabBarController(viewModel: DashboardViewModel())
        dashboardScreen.loadViewIfNeeded()

        return dashboardScreen
    }
    
    public func makeRecipeScreen(shortRecipe: ShortRecipe) -> RecipeContainerViewController {
        let recipeScreen = RecipeContainerViewController()
        recipeScreen.viewModel = RecipeContainerViewModel(shortRecipe: shortRecipe)
        recipeScreen.loadViewIfNeeded()
        
        return recipeScreen
    }

    public func makeCookingScreen(algorithm: Algorithm) -> CookingViewController {
        let cookingScreen = CookingViewController()
        cookingScreen.viewModel = CookingViewModel(algorithm: algorithm)
        cookingScreen.loadViewIfNeeded()
        
        return cookingScreen
    }

    public func makeSuccessScreen() -> SuccessViewController {
        let successScreen = SuccessViewController.make()
        successScreen.viewModel = SuccessViewModel(title: "Enjoy!", //TODO: Translations
                                                   imageName: "meal")
        successScreen.loadViewIfNeeded()
        
        return successScreen
    }
    
    public init() {}
}

public final class MainFlowController {
    private let theme: Theme
    private let idle: IdleConfigurable
    private let presenter: ScreenPresenter
    private let provider: ScreenMakeable
    private let disposeBag = DisposeBag()
    
    public func start() {
        presentDashboard(didSelectRecipe: { [weak self] shortRecipe in
            self?.presentRecipeDetails(shortRecipe: shortRecipe,
                                       didTapStartCooking: { [weak self] algorithm in
                                        self?.presentCookingScreen(algorithm: algorithm,
                                                                   didFinish: {
                                                                       self?.presentSuccessScreen()
                                                                   })
                                        })
        })
    }
    
    public init(presenter: ScreenPresenter,
                provider: ScreenMakeable = ScreenMaker(),
                idle: IdleConfigurable = Idle(),
                theme: Theme = DefaultTheme()) {
        self.idle = idle
        self.presenter = presenter
        self.provider = provider
        self.theme = theme
    }
}

private extension MainFlowController {
    func presentDashboard(didSelectRecipe: @escaping ((ShortRecipe) -> Void)) {
        let dashboardScreen = provider.makeDashboardScreen()
        dashboardScreen.apply(theme: theme)
        
        dashboardScreen.viewModel.didSelectRecipe
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { recipe in
                didSelectRecipe(recipe)
            })
            .disposed(by: dashboardScreen.disposeBag)
        
        presenter.pushViewController(dashboardScreen, animated: false)
        dashboardScreen.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func presentRecipeDetails(shortRecipe: ShortRecipe, didTapStartCooking: @escaping ((Algorithm) -> Void)) {
        let recipeScreen = provider.makeRecipeScreen(shortRecipe: shortRecipe)
        recipeScreen.apply(theme: theme)
        
        recipeScreen.viewModel.output.didTapStartCooking
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { algorithm in
                didTapStartCooking(algorithm)
            })
            .disposed(by: recipeScreen.disposeBag)
        
        recipeScreen.viewModel.output.didDismiss
            .subscribe { [weak self, weak recipeScreen] _ in
                _ = self?.presenter.popViewController(animated: true)
                recipeScreen?.navigationController?.setNavigationBarHidden(true, animated: true)
            }
            .disposed(by: recipeScreen.disposeBag)
        
        presenter.pushViewController(recipeScreen, animated: true)
        recipeScreen.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func presentCookingScreen(algorithm: Algorithm, didFinish: @escaping (() -> Void)) {
        let cookingScreen = provider.makeCookingScreen(algorithm: algorithm)
        cookingScreen.apply(theme: theme)
        
        cookingScreen.viewModel.output.didDismiss
            .subscribe { [weak self] _ in
                self?.idle.enable()
                _ = self?.presenter.popViewController(animated: true)
            }
            .disposed(by: cookingScreen.disposeBag)

        cookingScreen.viewModel.output.didFinish
            .observeOn(MainScheduler.instance)
            .subscribe { _ in
                didFinish()
            }
            .disposed(by: cookingScreen.disposeBag)
        
        idle.disable()
        presenter.pushViewController(cookingScreen, animated: true)
    }
    
    func presentSuccessScreen() {
        let successScreen = provider.makeSuccessScreen()
        successScreen.apply(theme: theme)
        
        successScreen.viewModel.output.didDismiss
            .observeOn(MainScheduler.instance).subscribe { [weak self] _ in
                _ = self?.presenter.popToRootViewController(animated: true)
            }
            .disposed(by: successScreen.disposeBag)
        
        presenter.pushViewController(successScreen, animated: true)
        successScreen.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
