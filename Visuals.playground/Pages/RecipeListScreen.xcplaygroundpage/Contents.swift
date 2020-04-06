//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import Core
import RxSwift
import RxRelay

let allRecipiesURL = URL(string: "https://raw.githubusercontent.com/ktustanowski/cooding/master/Recipes/recipes_list.json")!

var viewController = RecipeListContainerViewController.make()
viewController.viewModel = RecipeListContainerViewModel(recipeListURL: allRecipiesURL)

let (parent, _) = playgroundControllers(device: .phone47inch,
                                        child: viewController)

PlaygroundPage.current.liveView = parent
viewController.apply(theme: DarkTheme())

//: [Next](@next)
