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
}

public struct ScreenMaker: ScreenMakeable {
    public func makeDashboardScreen() -> DashboardTabBarController {
        let dashboardScreen = DashboardTabBarController()
        
        return dashboardScreen
    }
    
    public func makeRecipeScreen(shortRecipe: ShortRecipe) -> RecipeContainerViewController {
        let recipeScreen = RecipeContainerViewController()
        recipeScreen.viewModel = RecipeContainerViewModel(shortRecipe: shortRecipe)
        
        return recipeScreen
    }

    public func makeCookingScreen(algorithm: Algorithm) -> CookingViewController {
        let recipeScreen = CookingViewController()
        recipeScreen.viewModel = CookingViewModel(algorithm: algorithm)
        
        return recipeScreen
    }

    public init() {}
}

public final class MainFlowController {
    private let idle: IdleConfigurable
    private let presenter: ScreenPresenter
    private let provider: ScreenMakeable
    private let disposeBag = DisposeBag()
    
    public func start() {
        presentDashboard(didSelectRecipe: { [weak self] shortRecipe in
            self?.presentRecipeDetails(shortRecipe: shortRecipe,
                                       didTapStartCooking: { [weak self] algorithm in
                                            self?.presentCookingScreen(algorithm: algorithm)
                                        })
        })
    }
    
    public init(presenter: ScreenPresenter,
                provider: ScreenMakeable = ScreenMaker(),
                idle: IdleConfigurable = Idle()) {
        self.idle = idle
        self.presenter = presenter
        self.provider = provider
    }
}

private extension MainFlowController {
    func presentDashboard(didSelectRecipe: @escaping ((ShortRecipe) -> Void)) {
        let dashboardScreen = provider.makeDashboardScreen()
        dashboardScreen.apply(theme: DefaultTheme())
        
        dashboardScreen.viewModel.didSelectRecipe
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { recipe in
                didSelectRecipe(recipe)
            })
            .disposed(by: dashboardScreen.disposeBag)
        
        presenter.pushViewController(dashboardScreen, animated: false)
    }
    
    func presentRecipeDetails(shortRecipe: ShortRecipe, didTapStartCooking: @escaping ((Algorithm) -> Void)) {
        let recipeScreen = provider.makeRecipeScreen(shortRecipe: shortRecipe)
        recipeScreen.apply(theme: DefaultTheme())
        
        recipeScreen.viewModel.output.didTapStartCooking
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { algorithm in
                didTapStartCooking(algorithm)
            })
            .disposed(by: recipeScreen.disposeBag)
        
        recipeScreen.viewModel.output.didDismiss
            .subscribe { [weak self] _ in
                _ = self?.presenter.popViewController(animated: true)
            }
            .disposed(by: recipeScreen.disposeBag)
        
        presenter.pushViewController(recipeScreen, animated: true)
    }
    
    func presentCookingScreen(algorithm: Algorithm) {
        let cookingScreen = provider.makeCookingScreen(algorithm: algorithm)
        cookingScreen.apply(theme: DefaultTheme())
        
        cookingScreen.viewModel.output.didDismiss
            .subscribe { [weak self] _ in
                self?.idle.enable()
                _ = self?.presenter.popViewController(animated: true)
            }
            .disposed(by: cookingScreen.disposeBag)

        idle.disable()
        presenter.pushViewController(cookingScreen, animated: true)
    }
}
