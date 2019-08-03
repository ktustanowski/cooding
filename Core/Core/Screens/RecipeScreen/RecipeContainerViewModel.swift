//
//  RecipeContainerViewModel.swift
//  Core
//
//  Created by Kamil Tustanowski on 31/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

public protocol RecipeContainerViewModelProtocol: RecipeContainerViewModelProtocolInputs, RecipeContainerViewModelProtocolOutputs {
    var input: RecipeContainerViewModelProtocolInputs { get }
    var output: RecipeContainerViewModelProtocolOutputs { get }
}

public protocol RecipeContainerViewModelProtocolInputs {
    func viewDidLoad()
    func reload()
    func startCookingTapped()
    func dismiss()
}

public protocol RecipeContainerViewModelProtocolOutputs {
    var title: String { get }
    var recipeViewModel: Observable<RecipeViewModelProtocol?> { get }
    var isLoading: Observable<Bool> { get }
    var didTapStartCooking: Observable<Algorithm> { get }
    var didDismiss: Observable<Void> { get }
}

public final class RecipeContainerViewModel: RecipeContainerViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let downloader: DownloaderProtocol
    public var input: RecipeContainerViewModelProtocolInputs { return self }
    public var output: RecipeContainerViewModelProtocolOutputs { return self }
    
    // MARK: Inputs
    public func viewDidLoad() {
        viewDidLoadRelay.accept(())
    }
    
    public func reload() {
        reloadRelay.accept(())
    }
    
    public func startCookingTapped() {
        guard let algorithm = algorithm.value else { return }
        didTapStartCookingRelay.accept(algorithm)
    }
    
    public func dismiss() {
        didDismissRelay.accept(())
    }

    // MARK: Outputs
    public var title: String {
        return shortRecipe.name
    }
    public let recipeViewModel: Observable<RecipeViewModelProtocol?>
    public var didTapStartCooking: Observable<Algorithm> {
        return didTapStartCookingRelay.asObservable()
    }
    public let isLoading: Observable<Bool>
    public var didDismiss: Observable<Void> {
        return didDismissRelay.asObservable()
    }
    
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let reloadRelay = BehaviorRelay<Void>(value: ())
    private let didTapStartCookingRelay = PublishRelay<Algorithm>()
    private let didDismissRelay = PublishRelay<Void>()
    
    private let parser: AlgorithmParsable
    private let shortRecipe: ShortRecipe
    private var algorithm = BehaviorRelay<Algorithm?>(value: nil)
    
    public init(shortRecipe: ShortRecipe,
                downloader: DownloaderProtocol = Downloader(),
                parser: AlgorithmParsable = AlgorithmParser()) {
        self.shortRecipe = shortRecipe
        self.downloader = downloader
        self.parser = parser
        
        //TODOKT: when there is an error - whole chain is disposed - try to prevent that
        let viewDidLoad = viewDidLoadRelay.asObservable().debug("view_did")
        
        let shouldLoadRecipes = Observable
            .combineLatest(viewDidLoad,
                           reloadRelay.asObservable().debug("reload_obs"))
        
        let loadRecipe = shouldLoadRecipes
            .flatMap { _ -> Observable<Recipe?> in
                return downloader.download(url: shortRecipe.source)
                    .catchErrorJustReturn(nil)
            }
        
        let parseRawAlgorithm = loadRecipe
            .compactMap { $0 }
            .map { recipe in
                return parser.parse(string: recipe.rawAlgorithm)
            }
        
        parseRawAlgorithm
            .bind(to: algorithm)
            .disposed(by: disposeBag)
        
        recipeViewModel = loadRecipe
            .map { recipe in
                guard let recipe = recipe else { return nil }
                return RecipeViewModel(recipe: recipe)
            }
        
        isLoading = downloader.isLoading.asObservable()
    }
}
