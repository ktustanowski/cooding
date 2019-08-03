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

public protocol RecipeListContainerViewModelProtocol: RecipeListContainerViewModelProtocolInputs, RecipeListContainerViewModelProtocolOutputs {
    var input: RecipeListContainerViewModelProtocolInputs { get }
    var output: RecipeListContainerViewModelProtocolOutputs { get }
}

public protocol RecipeListContainerViewModelProtocolInputs {
    func viewDidLoad()
    func recipeList(url: URL?)
    func reload()
    func selected(recipe: ShortRecipe)
}

public protocol RecipeListContainerViewModelProtocolOutputs {
    var recipeListViewModel: Observable<RecipeListViewModelProtocol?> { get }
    var isLoading: Observable<Bool> { get }
    var didSelectRecipe: Observable<ShortRecipe> { get }
    var hasRecipeListURL: Observable<Bool> { get }
}

public final class RecipeListContainerViewModel: RecipeListContainerViewModelProtocol {
    private let downloader: DownloaderProtocol
    public var input: RecipeListContainerViewModelProtocolInputs { return self }
    public var output: RecipeListContainerViewModelProtocolOutputs { return self }
    
    // MARK: Inputs
    public func viewDidLoad() {
        viewDidLoadRelay.accept(())
    }
    
    public func recipeList(url: URL?) {
        recipeListURLRelay.accept(url)
    }
    
    public func reload() {
        reloadRelay.accept(())
    }

    public func selected(recipe: ShortRecipe) {
        didSelectRecipeRelay.accept(recipe)
    }

    // MARK: Outputs
    public let recipeListViewModel: Observable<RecipeListViewModelProtocol?>
    public let isLoading: Observable<Bool>

    private let recipeListURLRelay = BehaviorRelay<URL?>(value: nil)
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let reloadRelay = BehaviorRelay<Void>(value: ())
    private let didSelectRecipeRelay = PublishRelay<ShortRecipe>()
    public var didSelectRecipe: Observable<ShortRecipe> {
        return didSelectRecipeRelay.asObservable()
    }
    public var hasRecipeListURL: Observable<Bool> {
        return recipeListURLRelay
            .map { $0 != nil }
            .asObservable()
    }
    public init(recipeListURL: URL?, downloader: DownloaderProtocol = Downloader()) {
        self.downloader = downloader
        recipeListURLRelay.accept(recipeListURL)
    
        let viewDidLoad = viewDidLoadRelay.asObservable()
        let gotURL = recipeListURLRelay.asObservable()
        
        let shouldLoadRecipes = Observable
            .combineLatest(gotURL,
                           viewDidLoad,
                           reloadRelay.asObservable())
            .map { url, _, _ in url }
        
        recipeListViewModel = shouldLoadRecipes
            .flatMap { url -> Observable<RecipeList?> in
                guard let url = url else {
                    return .just(nil)
                }
                
                return downloader.download(url: url)
                    .catchErrorJustReturn(nil)
            }
            .map { recipe in
                guard let recipe = recipe else { return nil }
                return RecipeListViewModel(recipeList: recipe)
            }
        
        isLoading = downloader.isLoading.asObservable()
    }
}
