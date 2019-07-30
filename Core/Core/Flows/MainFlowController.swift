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
}

public struct ScreenMaker: ScreenMakeable {
    public func makeDashboardScreen() -> DashboardTabBarController {
        let dashboardScreen = DashboardTabBarController()
        
        return dashboardScreen
    }
    
    public init() {}
}

public final class MainFlowController {
    private let presenter: ScreenPresenter
    private let provider: ScreenMakeable
    private let disposeBag = DisposeBag()
    
    public func start() {
        presentDashboard(didSelectRecipe: { [weak self] recipe in
            self?.presentRecipeDetails(recipe: recipe)
        })
    }
    
    public init(presenter: ScreenPresenter, provider: ScreenMakeable = ScreenMaker()) {
        self.presenter = presenter
        self.provider = provider
    }
}

private extension MainFlowController {
    func presentDashboard(didSelectRecipe: @escaping ((ShortRecipe) -> Void)){
        let dashboardScreen = provider.makeDashboardScreen()
        
        dashboardScreen.viewModel.didSelectRecipe
            .subscribe(onNext: { recipe in
                didSelectRecipe(recipe)
            })
            .disposed(by: dashboardScreen.disposeBag)
        
        presenter.pushViewController(dashboardScreen, animated: false)
    }
    
    func presentRecipeDetails(recipe: ShortRecipe) {
        print(recipe) //TODO: Present recipe screen here
    }
}
