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
    func viewDidAppear()
    func viewWillAppear()
    func reload()
    func recipeList(url: URL?)
    func selected(recipe: ShortRecipe)
}

public protocol RecipeListContainerViewModelProtocolOutputs {
    var recipeListViewModel: Observable<RecipeListViewModelProtocol?> { get }
    var isLoading: Observable<Bool> { get }
    var didSelectRecipe: Observable<ShortRecipe> { get }
    var hasRecipeListURL: Observable<Bool> { get }
    var needsRecipesURL: Observable<Void> { get }
}

public final class RecipeListContainerViewModel: RecipeListContainerViewModelProtocol {
    private let storage: KeyValueStore
    private let downloader: DownloaderProtocol
    public var input: RecipeListContainerViewModelProtocolInputs { return self }
    public var output: RecipeListContainerViewModelProtocolOutputs { return self }
    
    // MARK: Inputs
    public func viewDidLoad() {
        viewDidLoadRelay.accept(())
    }
    
    public func viewDidAppear() {
        viewDidAppearRelay.accept(())
    }

    public func viewWillAppear() {
        viewWillAppearRelay.accept(())
    }

    public func recipeList(url: URL?) {
        guard let url = url else {
            recipeListURLRelay.accept(nil)
            return }
        
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
    public var needsRecipesURL: Observable<Void>

    private let recipeListURLRelay: BehaviorRelay<URL?>
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let viewDidAppearRelay = PublishRelay<Void>()
    private let reloadRelay = BehaviorRelay<Void>(value: ())
    private let viewWillAppearRelay = BehaviorRelay<Void>(value: ())
    private let didSelectRecipeRelay = PublishRelay<ShortRecipe>()
    public var didSelectRecipe: Observable<ShortRecipe> {
        return didSelectRecipeRelay.asObservable()
    }
    public var hasRecipeListURL: Observable<Bool> {
        return recipeListURLRelay
            .map { $0 != nil }
            .asObservable()
    }
    
    public init(recipeListURL: URL?,
                downloader: DownloaderProtocol = Downloader(),
                storage: KeyValueStore = UserDefaults.standard) {
        self.downloader = downloader
        self.storage = storage
        let recipeListURLRelay = BehaviorRelay<URL?>(value: recipeListURL)
        self.recipeListURLRelay = recipeListURLRelay
    
        let gotURL = recipeListURLRelay.asObservable().filter { $0 != nil }
        let noURL = recipeListURLRelay.asObservable().filter { $0 == nil }
                
        needsRecipesURL = Observable
            .combineLatest(noURL,
                           viewDidAppearRelay.asObservable())
            .map { _ in () }

        let shouldLoadRecipes = Observable
            .combineLatest(gotURL,
                           viewDidLoadRelay.asObservable(),
                           viewWillAppearRelay.asObservable(),
                           reloadRelay.asObservable())
            .map { _ in () }

        recipeListViewModel = shouldLoadRecipes
            .withLatestFrom(recipeListURLRelay.asObservable())
            .compactMap { $0 }
            .flatMap { url -> Observable<RecipeList?> in
                return downloader.download(url: url)
                    .catchErrorJustReturn(nil)
            }
            .map { recipe in
                guard let recipe = recipe else { return nil }
                return RecipeListViewModel(recipeList: recipe)
            }.do(onNext: {
                guard $0 != nil && recipeListURL == nil && storage.recipeListURL == nil else { return }
                storage.recipeListURL = recipeListURLRelay.value
            })
        
        isLoading = downloader.isLoading
            .distinctUntilChanged()
            .asObservable()
    }
}
