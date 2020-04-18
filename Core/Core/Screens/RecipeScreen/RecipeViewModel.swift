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

public enum RecipeCellType: IdentifiableType, Equatable {
    case imageCell(FullImageCellViewModel)
    case sliderCell(SliderCellViewModel)
    case listCell(ListCellViewModel)
    case buttonCell(ButtonCellViewModel)
    
    // TODO: Some other solution - supported not only with iOS13
    // TODO: Remove .hashValue - since its deprecated
    public var identity: some Hashable {
        switch self {
        case .imageCell(let viewModel):
            return viewModel.hashValue
        case .sliderCell(let viewModel):
            return viewModel.hashValue
        case .listCell(let viewModel):
            return viewModel.hashValue
        case .buttonCell(let viewModel):
            return viewModel.hashValue
        }
    }
}

public protocol RecipeViewModelProtocol: RecipeViewModelProtocolInputs, RecipeViewModelProtocolOutputs {
    var input: RecipeViewModelProtocolInputs { get }
    var output: RecipeViewModelProtocolOutputs { get }
}

public protocol RecipeViewModelProtocolInputs {
    func addPortion()
    func removePortion()
    func startCookingTapped()
}

public protocol RecipeViewModelProtocolOutputs {
    var items: Observable<[AnimatableSectionModel<String, RecipeCellType>]> { get }
    var didTapStartCooking: Observable<Void> { get }
    var titleForSliderCell: Observable<String> { get }
    var ingredients: Observable<String> { get }
}

public final class RecipeViewModel: RecipeViewModelProtocol {
    private let parser: AlgorithmParsing
    private let disposeBag = DisposeBag()
    
    public var input: RecipeViewModelProtocolInputs { return self }
    public var output: RecipeViewModelProtocolOutputs { return self }
        
    // MARK: Inputs
    public func addPortion() {
        peopleCount.accept(peopleCount.value + 1)
    }
    
    public func removePortion() {
        guard peopleCount.value > 1 else { return }
        peopleCount.accept(peopleCount.value - 1)
    }
    
    public func startCookingTapped() {
        didTapStartCookingRelay.accept(())
    }
    
    // MARK: Outputs
    public let items: Observable<[AnimatableSectionModel<String, RecipeCellType>]>
    
    public let didTapStartCooking: Observable<Void>
    private let didTapStartCookingRelay = PublishRelay<Void>()

    public let titleForSliderCell: Observable<String>
    public let ingredients: Observable<String>
    
    private let peopleCount = BehaviorRelay<Int>(value: 1)
    private let quantityMultiplier: Observable<Float>

    public init(recipe: Recipe, algorithmParser: AlgorithmParsing = AlgorithmParser()) {
        self.parser = algorithmParser
        let algorithm = parser.parse(string: recipe.rawAlgorithm)
        peopleCount.accept(recipe.people)
        
        didTapStartCooking = didTapStartCookingRelay.asObservable()
        quantityMultiplier = peopleCount
            .map {  Float($0) / Float(recipe.people) }
            
        titleForSliderCell = peopleCount
            .map { "\("portions".localized) - \($0)" }            
                
        ingredients = quantityMultiplier
            .map { multiplier in
                algorithm.ingredients
                    .reduce("") { ingredientsList, ingredient in
                        return ingredientsList + "• \(ingredient.format(multiplier: multiplier))\n"
                }
        }
        
        let ingredientsCellViewModel = ingredients
            .distinctUntilChanged()
            .map { ingredients in
                ListCellViewModel(title: "\(algorithm.ingredients.count) \("ingredients".localized)",
                    description: ingredients)
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
        
        let ingredientsCell = ingredientsCellViewModel.map { RecipeCellType.listCell($0) }
        
        let dependenciesCell = RecipeCellType.listCell(ListCellViewModel(title: "\(algorithm.dependencies.count) \("dependencies".localized)".localized,
                                                                         description: dependencies))
        
        let stepsCell = RecipeCellType.listCell(ListCellViewModel(title: "\(algorithm.steps.count) \("steps".localized)",
                                                                  description: steps))
        
        let startCookingCell = RecipeCellType.buttonCell(ButtonCellViewModel(title: "recipe.screen.action.button.title".localized))
        
        //TODO: Display only cell which have content.
        items = Observable
            .merge(ingredientsCell)
            .map { ingredientsCell in
                return [AnimatableSectionModel(model: "MainSection",
                                               items: [imageCell,
                                                       ingredientsCell,
                                                       dependenciesCell,
                                                       stepsCell,
                                                       startCookingCell])]
        }
        .distinctUntilChanged()
    }
}
