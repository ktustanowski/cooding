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
    func refreshTapped()
}

public protocol RecipeListViewModelProtocolOutputs {
    var recipes: Observable<[FullImageCellViewModel]> { get }
    
    var didSelectRecipe: Observable<ShortRecipe> { get }
    // TODOKT: Add refresh here too
//    TODOKT: Seems I need to propagate this up to container - I forgot about it
}

public final class RecipeListViewModel: RecipeListViewModelProtocol {
    public func refreshTapped() {
        // TODOKT: Propagate this up to container view model!
    }
    
    public var input: RecipeListViewModelProtocolInputs { return self }
    public var output: RecipeListViewModelProtocolOutputs { return self }
    
    // MARK: Inputs
    public func itemSelected(indexPath: IndexPath) {
        let recipe = recipeList.recipes[indexPath.row]
        didSelectRecipeRelay.accept(recipe)
    }
        
    // MARK: Outputs
    public var recipes: Observable<[FullImageCellViewModel]>
    public var didSelectRecipe: Observable<ShortRecipe> {
        return didSelectRecipeRelay.asObservable()
    }
    public var didSelectRecipeRelay = PublishRelay<ShortRecipe>()
    
    private let recipeList: RecipeList
    
    public init(recipeList: RecipeList) {
        self.recipeList = recipeList
        recipes = .just(recipeList.recipes
            .map { FullImageCellViewModel(title: $0.name,
                                          imageURL: $0.imageURL,
                                          shrinksOnTouch: true) })
    }
}
