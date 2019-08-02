import UIKit
import PlaygroundSupport
import Core
import RxSwift
import RxRelay

//swiftlint:disable line_length
extension String {
    static var loremIpsumMedium: String = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
    """
    
    static var loremIpsumLong: String = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    """
}
//swiftlint:enable line_length

let steps = [Step(description: "Prepare blender",
                  dependencies: [Dependency(name: "blender")],
                  ingredients: nil),
             Step(description: .loremIpsumMedium,
                  dependencies: [Dependency(name: "blender")],
                  ingredients: nil, duration: 15),
             Step(description: "Add 1 heaping teaspoon of baking powder to the blender",
                  dependencies: [Dependency(name: "Blender")],
                  ingredients: [Ingredient(name: "heaping teaspoon of baking powder", quantity: 1.0)]),
             Step(description: "Add 1.25 glass of buttermilk to the blender",
                  dependencies: [Dependency(name: "Blender")],
                  ingredients: [Ingredient(name: "glass off buttermilk", quantity: 1.25)]),
             Step(description: "Add 0.25 glass of powdered sugar to the blender",
                  dependencies: [Dependency(name: "blender")],
                  ingredients: [Ingredient(name: "powdered sugar", quantity: 0.25)]),
             Step(description: "Add 1 heaping teaspoon of baking powder to the blender",
                  dependencies: [Dependency(name: "Blender")],
                  ingredients: [Ingredient(name: "heaping teaspoon of baking powder", quantity: 1.0)]),
             Step(description: .loremIpsumLong,
                  dependencies: [Dependency(name: "Blender")],
                  ingredients: [Ingredient(name: "heaping teaspoon of baking powder", quantity: 1.0)],
                  duration: 60)
]

var cookingViewController = CookingViewController()
cookingViewController.viewModel = CookingViewModel(algorithm: Algorithm(ingredients: [],
                                                                        steps: steps,
                                                                        dependencies: []))
var navigationController = UINavigationController(rootViewController: cookingViewController)

PlaygroundPage.current.liveView = navigationController.view

navigationController.view.frame = CGRect(x: 0, y: 0, width: 320, height: 480)

PlaygroundPage.current.needsIndefiniteExecution = true
