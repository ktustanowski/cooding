//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import Core
import RxSwift
import RxRelay

var recipeViewController = RecipeContainerViewController()
recipeViewController.viewModel = RecipeContainerViewModel(shortRecipe: ShortRecipe(name: "Pancakes",
                                                                                   source: URL(string: "https://raw.githubusercontent.com/ktustanowski/recipes/master/pancakes.json")!,
                                                                                   image: URL(string: "https://cdn.pixabay.com/photo/2016/10/27/22/07/pancake-1776646_1280.jpg")!))
var navigationController = UINavigationController(rootViewController: recipeViewController)

PlaygroundPage.current.liveView = navigationController.view
PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
