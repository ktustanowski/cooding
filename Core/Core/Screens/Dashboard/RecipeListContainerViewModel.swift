//
//  RecipeListContainerViewModel.swift
//  Core
//
//  Created by Kamil Tustanowski on 30/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

let disposeBag = DisposeBag()
let downloader = Downloader()

public protocol RecipeListContainerViewModelProtocol: RecipeListContainerViewModelProtocolInputs, RecipeListContainerViewModelProtocolOutputs {
    var input: RecipeListContainerViewModelProtocolInputs { get }
    var output: RecipeListContainerViewModelProtocolOutputs { get }
}

public protocol RecipeListContainerViewModelProtocolInputs {
    func viewDidLoad()
    func recipe(url: URL)
    func reload()
    func selected(recipe: ShortRecipe)
}

public protocol RecipeListContainerViewModelProtocolOutputs {
    var recipeListViewModel: Observable<RecipeListViewModelProtocol> { get }
    var isLoading: Observable<Bool> { get }
    var didSelectRecipe: Observable<ShortRecipe> { get }
}

public final class RecipeListContainerViewModel: RecipeListContainerViewModelProtocol {
    private let downloader: DownloaderProtocol
    public var input: RecipeListContainerViewModelProtocolInputs { return self }
    public var output: RecipeListContainerViewModelProtocolOutputs { return self }
    
    // MARK: Inputs
    public func viewDidLoad() {
        viewDidLoadRelay.accept(())
    }
    
    public func recipe(url: URL) {
        recipeURLRelay.accept(url)
    }
    
    public func reload() {
        reloadRelay.accept(())
    }

    public func selected(recipe: ShortRecipe) {
        didSelectRecipeRelay.accept(recipe)
    }

    // MARK: Outputs
    public let recipeListViewModel: Observable<RecipeListViewModelProtocol>
    public let isLoading: Observable<Bool>

    private let recipeURLRelay = BehaviorRelay<URL?>(value: nil)
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let reloadRelay = BehaviorRelay<Void>(value: ())
    private let didSelectRecipeRelay = PublishRelay<ShortRecipe>()
    public var didSelectRecipe: Observable<ShortRecipe> {
        return didSelectRecipeRelay.asObservable()
    }

    public init(recipeURL: URL?, downloader: DownloaderProtocol = Downloader()) {
        self.downloader = downloader
        recipeURLRelay.accept(recipeURL)
    
        //TODOKT: After first time this whole chain is disposed
        let viewDidLoad = viewDidLoadRelay.asObservable().debug("view_did")
        let gotURL = recipeURLRelay.asObservable().debug("recipe_relay")
            .compactMap { $0 }
        
        let shouldLoadRecipes = Observable
            .combineLatest(gotURL,
                           viewDidLoad,
                           reloadRelay.asObservable().debug("reload_obs"))
            .map { $0.0 }.debug("should_load")
        
        recipeListViewModel = shouldLoadRecipes.asObservable()
            .flatMap { url -> Observable<RecipeList> in
                return downloader.download(url: url)
            }
            .map { RecipeListViewModel(recipeList: $0) }
        
        isLoading = downloader.isLoading.asObservable()
    }
    
    deinit {
        print("deinitied")
    }
}
