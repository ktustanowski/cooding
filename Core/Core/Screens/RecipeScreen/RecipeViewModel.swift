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

public typealias RecipeSectionModel = SectionModel<RecipeSection, RecipeItem>

public enum RecipeSection: CaseIterable {
    case info
    case ingredients
    case dependencies
    case steps
}

public enum RecipeItem {
    case info(viewModel: BasicCellViewModel)
    case ingredient(viewModel: BasicCellViewModel)
    case dependency(viewModel: BasicCellViewModel)
    case step(viewModel: BasicCellViewModel)
}

public protocol RecipeViewModelProtocol: RecipeViewModelProtocolInputs, RecipeViewModelProtocolOutputs {
    var input: RecipeViewModelProtocolInputs { get }
    var output: RecipeViewModelProtocolOutputs { get }
}

public protocol RecipeViewModelProtocolInputs {
    
}

public protocol RecipeViewModelProtocolOutputs {
    var sections: Observable<[RecipeSectionModel]> { get }
}

public final class RecipeViewModel: RecipeViewModelProtocol {
    private let parser: AlgorithmParsable
    
    public var input: RecipeViewModelProtocolInputs { return self }
    public var output: RecipeViewModelProtocolOutputs { return self }
    
    // MARK: Outputs
    private let sectionsRelay = BehaviorRelay<[RecipeSectionModel]>(value: [])
    public let sections: Observable<[RecipeSectionModel]>
    
    public init(recipe: Recipe, algorithmParser: AlgorithmParsable = AlgorithmParser()) {
        //TODO: Update implementation to load from web
        self.parser = algorithmParser
        let algorithm = parser.parse(string: recipe.rawAlgorithm)

        let ingredientsSectionContent = RecipeSectionModel(model: .ingredients,
                                                          items: algorithm.ingredients
                                                            .map { RecipeItem.ingredient(viewModel: BasicCellViewModel(title: $0.formatted))})

        let dependenciesSectionContent = RecipeSectionModel(model: .dependencies,
                                                           items: algorithm.dependencies
                                                            .map { RecipeItem.dependency(viewModel: BasicCellViewModel(title: $0.name))})

        let stepsSectionContent = RecipeSectionModel(model: .steps,
                                                     items: algorithm.steps
                                                        .map { RecipeItem.step(viewModel: BasicCellViewModel(title: $0.description))})
        sections = .just([ingredientsSectionContent,
                          dependenciesSectionContent,
                          stepsSectionContent])
//        sections = .just([])
    }
}

// TODO: Refactor to regular VM
public class BasicCellViewModel {
    public var title: String
    
    public init(title: String) {
        self.title = title
    }
}

public class BasicTableCell: UITableViewCell {
    public var viewModel: BasicCellViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

private extension BasicTableCell {
    func bindViewModel() {
        textLabel?.text = viewModel.title
    }
}
