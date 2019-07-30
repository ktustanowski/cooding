//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import Core
import RxSwift
import RxRelay

var recipeViewController = RecipeViewController()
var navigationController = UINavigationController(rootViewController: recipeViewController)

//let liveView = playgroundControllers(child: recipeViewController)
PlaygroundPage.current.liveView = navigationController.view
PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
