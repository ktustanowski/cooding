import Foundation
import UIKit
import Core
import PlaygroundSupport

/*:
 ⚠️ Please turn on "Render Documentation" from the "right menu".
 ⚠️ Please select assistant editor from top left selectors (middle one with circles intersecting), and then select Live View.
 
 # Welcome to recipe creator!
 
 First enter algorithm steps needed to make the meal. You can write anything you want, any way you want - remember the better you structure this the better your cooking experience will be.
 Make sure each step is encapsulated. That it represents a piece you can read and then do. Without needing to check any other steps or ingredients list etc.
 When you write - use natural language and just:
 - wrap ingredients in [] i.e [1.0 egg] (plese use 1.0 rather than 1)
 - wrap dependencies in {} i.e. {frying pan}
 - if step is meant to take some time wrap seconds (duration of the action) in <> i.e. "Boil the egg <600>"
 
 And thats all. You just enter each step and ingredients list and all dependencies are generated based on what you add. No additional work and book keeping needed.
 
 # 1. Enter your recipe (algorithm) steps here:
 Check the example ones first. What is important - each step must be in a separate line.
 Please check the console during writing (if you have auto-compile turned on) or compile yourself.
 You can see exactly how you recipe will look like in the app in the console output.
 ⚠️ But... if you start Live View - you will see actual screen from the app with your recipe inside - cool, right?
 */
var rawAlgorithm = """
Prepare {blender}
Add [1 egg] to the {blender}
Blend <60>
"""
/*:
 Validation and printing part. This prints parsed recipe stuff to the console.
 */
let parser = AlgorithmParser()
let algorithm = parser.parse(string: rawAlgorithm)

print("\n🥚 \(algorithm.ingredients.count) Ingredients ")
algorithm.ingredients
    .forEach { print("- \($0.quantity) \($0.name)") }

print("\n🍳 \(algorithm.dependencies.count) Dependencies ")
algorithm.dependencies
    .forEach { print("- \($0.name)") }

print("\n⚙️ \(algorithm.steps.count) Algorithm steps ")
algorithm.steps
    .forEach {
        print(" - \($0.description) \($0.duration != nil ? "for \($0.duration!)" : "") ")
        $0.ingredients?
            .forEach { ingredient in print("|\(ingredient.quantity) \(ingredient.name)") }
        $0.dependencies?
            .forEach { dependency in print("|\(dependency.name)") }
    }
/*:
 2. Enter more info about recipe here
 */
let yourRecipe = Recipe(name: "Recipe name i.e. Pancakes",
                        authorName: "Your name i.e. Luke Starkiller",
                        authorURL: nil, // Pass you githiub, twitter, linkedin etc. if you want
                        originalSourceURL: URL(string: "http://url.to.site.where.this.comes.from.if.ie.found.online")!,
                        imagesURL: [URL(string: "https://images.unsplash.com/photo-1563690449029-d6e1b8d6003d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1346&q=80")!],
                        rawAlgorithm: rawAlgorithm,
                        time: 60 * 30, // How long does it take to preapre - in seconds
                        people: 1, // How many people will be satified with this portion
                        difficulty: .easy,
                        country: nil) // Is this regional food?

/*:
 Another validation and printing part
 */

let recipeJSONString = yourRecipe.repositoryJSON

let jsonData = recipeJSONString.data(using: .utf8)!
let decodedRecipe = try? JSONDecoder().decode(Recipe.self, from: jsonData)

if decodedRecipe == nil {
    print("\n🔴 Oops! There something wrong - your recipe wasn't decoded properly")
} else {
    print("\n✅ All good. You can just paste this json to a recipe file and you will see it in the app.")
    print("\n\nUse this JSON in you recipe repository:\n")
    print("=============================================")
    print(recipeJSONString)
    print("=============================================")
}

let viewController = RecipeViewController()
viewController.viewModel = RecipeViewModel(recipe: yourRecipe)
viewController.loadViewIfNeeded()
viewController.apply(theme: DarkTheme())

var navigationController = UINavigationController(rootViewController: viewController)

let (parent, _) = playgroundControllers(device: .phone47inch,
                                        child: navigationController)

PlaygroundPage.current.liveView = parent
/*:
 [All recipes section in the app]:
 https://github.com/ktustanowski/cooding/blob/master/Recipes/recipes_list.json "Thanks for considering!"
 
 # Thats all!
 Now just create an empty file in yoru recipe repository and paste the json you get from the console. Then add URL to this recipe to your recipe list json.
 Please also consider adding the recipe to [All recipes section in the app]. It would be awesome!
 If you want to share your recipe just fork the cooding repository (url [All recipes section in the app]), add your recipe url and create a Pull Request.
 If you want to see a working example of recipe repository please check https://github.com/ktustanowski/recipes
 
 Thanks for trying out Cooding!
 Bon appétit!
 
 # Note: Github caches data and when adding recipes you have to wait a few minutes to actually see them in the app
 */
