//
//  DashboardViewModel.swift
//  Core
//
//  Created by Kamil Tustanowski on 30/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

public protocol DashboardViewModelProtocol: DashboardViewModelProtocolInputs, DashboardViewModelProtocolOutputs {
    var input: DashboardViewModelProtocolInputs { get }
    var output: DashboardViewModelProtocolOutputs { get }
}

public protocol DashboardViewModelProtocolInputs {
    func selected(recipe: ShortRecipe)
}

public protocol DashboardViewModelProtocolOutputs {
    var allRecipiesViewModel: RecipeListContainerViewModelProtocol { get }
    var myRecipiesViewModel: RecipeListContainerViewModelProtocol { get }
    var allRecipiesButtonTitle: String { get }
    var myRecipiesButtonTitle: String { get }
    var didSelectRecipe: Observable<ShortRecipe> { get }
}

public final class DashboardViewModel: DashboardViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let allRecipiesURL = URL(string: "https://raw.githubusercontent.com/ktustanowski/cooding/master/Recipes/recipes_list.json")!

    public var input: DashboardViewModelProtocolInputs { return self }
    public var output: DashboardViewModelProtocolOutputs { return self }

    // MARK : Input
    public func selected(recipe: ShortRecipe) {
        didSelectRecipeRelay.accept(recipe)
    }
    
    // MARK : Output
    public var allRecipiesViewModel: RecipeListContainerViewModelProtocol
    public var allRecipiesButtonTitle: String
    
    public var myRecipiesViewModel: RecipeListContainerViewModelProtocol
    public var myRecipiesButtonTitle: String
    
    public var didSelectRecipe: Observable<ShortRecipe> {
        return didSelectRecipeRelay.asObservable()
    }
    
    private var didSelectRecipeRelay = PublishRelay<ShortRecipe>()
    
    public init(storage: KeyValueStore = UserDefaults.standard) {
        allRecipiesViewModel = RecipeListContainerViewModel(recipeListURL: allRecipiesURL)
        allRecipiesButtonTitle = "All" // TODO: Translations

        myRecipiesViewModel = RecipeListContainerViewModel(recipeListURL: storage.recipeListURL)
        myRecipiesButtonTitle = "My" // TODO: Translations
    }
}
