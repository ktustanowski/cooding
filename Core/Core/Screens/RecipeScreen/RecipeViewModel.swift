//
//  RecipeViewModel.swift
//  Core
//
//  Created by Kamil Tustanowski on 28/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import RxDataSources

public protocol RecipeViewModelProtocol: RecipeViewModelProtocolInputs, RecipeViewModelProtocolOutputs {
    var input: RecipeViewModelProtocolInputs { get }
    var output: RecipeViewModelProtocolOutputs { get }
}

public protocol RecipeViewModelProtocolInputs {
    
}

public protocol RecipeViewModelProtocolOutputs {
    var items: Observable<[ListCellViewModel]> { get }
}

public final class RecipeViewModel: RecipeViewModelProtocol {
    private let parser: AlgorithmParsable
    
    public var input: RecipeViewModelProtocolInputs { return self }
    public var output: RecipeViewModelProtocolOutputs { return self }
    
    // MARK: Outputs
    public let items: Observable<[ListCellViewModel]>
    
    public init(recipe: Recipe, algorithmParser: AlgorithmParsable = AlgorithmParser()) {
        self.parser = algorithmParser
        let algorithm = parser.parse(string: recipe.rawAlgorithm)

        let ingredients = algorithm.ingredients
            .reduce("") { ingredientsList, ingredient in
                return ingredientsList + "• \(ingredient.formatted)\n"
            }
        
        let dependencies = algorithm.dependencies
            .reduce("") { dependenciesList, dependency in
                return dependenciesList + "• \(dependency.name)\n"
        }

        let steps = algorithm.steps
            .reduce("") { stepsList, step in
                return stepsList + "• \(step.description)\n"
        }

        items = .just([ListCellViewModel(title: "\(algorithm.ingredients.count) Ingredients", //TODO: Translations
                                         description: ingredients),
                       ListCellViewModel(title: "\(algorithm.dependencies.count) Dependencies", //TODO: Translations
                                         description: dependencies),
                       ListCellViewModel(title: "\(algorithm.steps.count) Steps", //TODO: Translations
                                         description: steps)])
    }
}
