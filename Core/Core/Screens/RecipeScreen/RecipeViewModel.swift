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

public enum RecipeCellType {
    case listCell(ListCellViewModel)
    case buttonCell(ButtonCellViewModel)
}

public protocol RecipeViewModelProtocol: RecipeViewModelProtocolInputs, RecipeViewModelProtocolOutputs {
    var input: RecipeViewModelProtocolInputs { get }
    var output: RecipeViewModelProtocolOutputs { get }
}

public protocol RecipeViewModelProtocolInputs {
    func startCookingTapped()
}

public protocol RecipeViewModelProtocolOutputs {
    var items: Observable<[SectionModel<String, RecipeCellType>]> { get }
    var didTapStartCooking: Observable<Void> { get }
}

public final class RecipeViewModel: RecipeViewModelProtocol {
    private let parser: AlgorithmParsable
    
    public var input: RecipeViewModelProtocolInputs { return self }
    public var output: RecipeViewModelProtocolOutputs { return self }
    
    // MARK: Inputs
    public func startCookingTapped() {
        didTapStartCookingRelay.accept(())
    }
    
    // MARK: Outputs
    public let items: Observable<[SectionModel<String, RecipeCellType>]>
    public var didTapStartCooking: Observable<Void> {
        return didTapStartCookingRelay.asObservable()
    }
    
    private let didTapStartCookingRelay = PublishRelay<Void>()
    
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
        
        items = .just([SectionModel(model: "MainSection", items: [RecipeCellType.listCell(ListCellViewModel(title: "\(algorithm.ingredients.count) Ingredients", //TODO: Translations
            description: ingredients)),
                                                                         RecipeCellType.listCell(ListCellViewModel(title: "\(algorithm.dependencies.count) Dependencies", //TODO: Translations
                                                                            description: dependencies)),
                                                                         RecipeCellType.listCell(ListCellViewModel(title: "\(algorithm.steps.count) Steps", //TODO: Translations
                                                                            description: steps)),
                                                                         RecipeCellType.buttonCell(ButtonCellViewModel(title: "Start Cooking"))])]) //TODO: Translations)
    }
}
