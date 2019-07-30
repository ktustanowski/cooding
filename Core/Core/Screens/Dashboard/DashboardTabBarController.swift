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
    //TODO: Investigate why view did load was called immediatelly after creation - and this vm needed to be moved inside
    var viewModel: DashboardViewModelProtocol! = DashboardViewModel()
    public var disposeBag = DisposeBag()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension DashboardTabBarController {
    func setup() {
        hidesBottomBarWhenPushed = true
        viewControllers = [makeAllRecipes()]
    }
    
    func makeAllRecipes() -> UIViewController {
        let viewController = RecipeListContainerViewController.make()
        viewController.viewModel = viewModel.output.allRecipiesViewModel

        viewController.viewModel.output.didSelectRecipe
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] recipe in
                self?.viewModel.input.selected(recipe: recipe)
            })
            .disposed(by: viewController.disposeBag)
        
        viewController.tabBarItem = UITabBarItem(title: viewModel.output.allRecipiesButtonTitle, //TODO: Translations
            image: nil,
            selectedImage: nil)

        return viewController
    }
}
