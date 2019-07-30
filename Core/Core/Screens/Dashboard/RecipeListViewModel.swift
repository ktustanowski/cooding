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
    var recipies: Observable<[BasicCellViewModel]> { get }
    var didSelectRecipe: Observable<ShortRecipe> { get }
}

public final class RecipeListViewModel: RecipeListViewModelProtocol {
    public var input: RecipeListViewModelProtocolInputs { return self }
    public var output: RecipeListViewModelProtocolOutputs { return self }
    
    // MARK: Outputs
    public func itemSelected(indexPath: IndexPath) {
        let recipe = recipeList.recipes[indexPath.row]
        didSelectRecipeRelay.accept(recipe)
    }
    
    // MARK: Outputs
    public var recipies: Observable<[BasicCellViewModel]>
    public var didSelectRecipe: Observable<ShortRecipe> {
        return didSelectRecipeRelay.asObservable()
    }
    public var didSelectRecipeRelay = PublishRelay<ShortRecipe>()
    
    private let recipeList: RecipeList
    
    public init(recipeList: RecipeList) {
        self.recipeList = recipeList
        recipies = .just(recipeList.recipes
            .map { BasicCellViewModel(title: $0.name) })
    }
}
