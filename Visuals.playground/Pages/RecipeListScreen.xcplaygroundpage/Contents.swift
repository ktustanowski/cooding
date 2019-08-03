//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import Core
import RxSwift
import RxRelay

let allRecipiesURL = URL(string: "https://raw.githubusercontent.com/ktustanowski/cooding/master/Recipes/recipes_list.json")!
var viewController = RecipeListContainerViewController.make()
viewController.viewModel = RecipeListContainerViewModel(recipeListURL: allRecipiesURL, downloader: Downloader())
viewController.loadViewIfNeeded()


PlaygroundPage.current.liveView = viewController.view
PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
