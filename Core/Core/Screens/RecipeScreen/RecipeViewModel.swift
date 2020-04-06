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
    case imageCell(FullImageCellViewModel)
    case sliderCell(SliderCellViewModel)
    case listCell(ListCellViewModel)
    case buttonCell(ButtonCellViewModel)
}

public protocol RecipeViewModelProtocol: RecipeViewModelProtocolInputs, RecipeViewModelProtocolOutputs {
    var input: RecipeViewModelProtocolInputs { get }
    var output: RecipeViewModelProtocolOutputs { get }
}

public protocol RecipeViewModelProtocolInputs {
    func selected(peopleCount: Int)
    func startCookingTapped()
}

public protocol RecipeViewModelProtocolOutputs {
    var items: Observable<[SectionModel<String, RecipeCellType>]> { get }
    var didTapStartCooking: Observable<Void> { get }
    func titleForSliderCell(for value: Int) -> String
}

public final class RecipeViewModel: RecipeViewModelProtocol {
    private let parser: AlgorithmParsing
    
    public var input: RecipeViewModelProtocolInputs { return self }
    public var output: RecipeViewModelProtocolOutputs { return self }
    
    // MARK: Inputs
    public func selected(peopleCount: Int) {
        // TODO: Update multiplier
    }
    
    public func startCookingTapped() {
        didTapStartCookingRelay.accept(())
    }
    
    // MARK: Outputs
    public let items: Observable<[SectionModel<String, RecipeCellType>]>
    public var didTapStartCooking: Observable<Void> {
        return didTapStartCookingRelay.asObservable()
    }
    
    private let didTapStartCookingRelay = PublishRelay<Void>()
    
    public func titleForSliderCell(for value: Int) -> String {
        return "\("portions".localized) - \(value)"
    }
    
    public init(recipe: Recipe, algorithmParser: AlgorithmParsing = AlgorithmParser()) {
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
        
        let imageCell = RecipeCellType.imageCell(FullImageCellViewModel(title: nil,
                                                                        imageURL: recipe.imagesURL?.first))
        
        var portions = Float(recipe.people ?? 1)
        let sliderCell = RecipeCellType.sliderCell(SliderCellViewModel(minimum: 1,
                                                                       maximum: Float(Constants.general.maxPortions),
                                                                       value: portions))
        
        let ingredientsCell = RecipeCellType.listCell(ListCellViewModel(title: "\(algorithm.ingredients.count) \("ingredients".localized)",
                                                                        description: ingredients))
        
        let dependenciesCell = RecipeCellType.listCell(ListCellViewModel(title: "\(algorithm.dependencies.count) \("dependencies".localized)".localized,
                                                                         description: dependencies))
        
        let stepsCell = RecipeCellType.listCell(ListCellViewModel(title: "\(algorithm.steps.count) \("steps".localized)",
                                                                  description: steps))
        
        let startCookingCell = RecipeCellType.buttonCell(ButtonCellViewModel(title: "recipe.screen.action.button.title".localized))
        
        //TODO: Display only cell which have content.
        items = .just([SectionModel(model: "MainSection", items: [imageCell,
                                                                  sliderCell,
                                                                  ingredientsCell,
                                                                  dependenciesCell,
                                                                  stepsCell,
                                                                  startCookingCell])])
        
    }
}
