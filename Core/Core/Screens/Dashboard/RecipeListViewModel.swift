//
//  RecipeListViewModel.swift
//  Core
//
//  Created by Kamil Tustanowski on 29/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

public protocol RecipeListViewModelProtocol: RecipeListViewModelProtocolInputs, RecipeListViewModelProtocolOutputs {
    var input: RecipeListViewModelProtocolInputs { get }
    var output: RecipeListViewModelProtocolOutputs { get }
}

public protocol RecipeListViewModelProtocolInputs {
    func itemSelected(indexPath: IndexPath)
}

public protocol RecipeListViewModelProtocolOutputs {
    var recipes: Observable<[FullImageCellViewModel]> { get }
    var didSelectRecipe: Observable<ShortRecipe> { get }
}

public final class RecipeListViewModel: RecipeListViewModelProtocol {
    public var input: RecipeListViewModelProtocolInputs { return self }
    public var output: RecipeListViewModelProtocolOutputs { return self }
    
    // MARK: Inputs
    public var didSelectRecipeRelay = PublishRelay<ShortRecipe>()
    public func itemSelected(indexPath: IndexPath) {
        let recipe = recipeList.recipes[indexPath.row]
        didSelectRecipeRelay.accept(recipe)
    }

    // MARK: Outputs
    public var recipes: Observable<[FullImageCellViewModel]>
    public var didSelectRecipe: Observable<ShortRecipe> {
        return didSelectRecipeRelay.asObservable()
    }
    
    private let recipeList: RecipeList
    
    public init(recipeList: RecipeList) {
        self.recipeList = recipeList
        recipes = .just(recipeList.recipes
            .map { FullImageCellViewModel(title: $0.name,
                                          imageURL: $0.imageURL,
                                          shrinksOnTouch: true) })
    }
}
