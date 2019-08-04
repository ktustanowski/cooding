//: [Previous](@previous)
import UIKit
import PlaygroundSupport
import Core
import RxSwift
import RxRelay

var viewController = RecipeListViewController()
let pancakes = ShortRecipe(name: "Pancakes", sourceURL: URL(string: "https://google.com")!, imageURL: URL(string: "https://google.com")!)

let scrambledEggs = ShortRecipe(name: "Scrambled eggs", sourceURL: URL(string: "https://google.com")!, imageURL: URL(string: "https://google.com")!)

let bioledEggs = ShortRecipe(name: "Boiled eggs", sourceURL: URL(string: "https://google.com")!, imageURL: URL(string: "https://google.com")!)

let recipeList = RecipeList(recipes: [pancakes, scrambledEggs, bioledEggs])
viewController.viewModel = RecipeListViewModel(recipeList: recipeList)
viewController.apply(theme: DefaultTheme())

PlaygroundPage.current.liveView = PlaygroundPresenter.presenter(for: viewController)
//: [Next](@next)
