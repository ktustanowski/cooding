//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import Core
import RxSwift
import RxRelay

var viewController = RecipeContainerViewController()
viewController.viewModel = RecipeContainerViewModel(shortRecipe: ShortRecipe(name: "Pancakes",
                                                                                   sourceURL: URL(string: "https://raw.githubusercontent.com/ktustanowski/recipes/master/pancakes.json")!,
                                                                                   imageURL: URL(string: "https://cdn.pixabay.com/photo/2016/10/27/22/07/pancake-1776646_1280.jpg")!))
viewController.apply(theme: DarkTheme())
var navigationController = UINavigationController(rootViewController: viewController)

let (parent, _) = playgroundControllers(device: .phone47inch,
                                        child: navigationController)

PlaygroundPage.current.liveView = parent

//: [Next](@next)
