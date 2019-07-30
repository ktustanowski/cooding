//: [Previous](@previous)
import UIKit
import PlaygroundSupport
import Core
import RxSwift
import RxRelay

var viewController = RecipeListViewController()
let pancakes = ShortRecipe(name: "Pancakes", source: URL(string: "https://google.com")!, image: URL(string: "https://google.com")!)

let scrambledEggs = ShortRecipe(name: "Scrambled eggs", source: URL(string: "https://google.com")!, image: URL(string: "https://google.com")!)

let recipeList = RecipeList(recipes: [pancakes, scrambledEggs])
viewController.viewModel = RecipeListViewModel(recipeList: recipeList)

PlaygroundPage.current.liveView = viewController.view
PlaygroundPage.current.needsIndefiniteExecution = true
//: [Next](@next)
