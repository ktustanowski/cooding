//: [Previous](@previous)

import Foundation
import Core
//swiftlint:disable line_length
let pancakes = """
:: version 0.1\nPrepare {blender}\nAdd [1.25 glass of buttermilk] to the {blender}\nAdd [0.25 glass of powdered sugar] to the {blender}\nAdd [1.0 heaping teaspoon of baking powder] to the {blender}\nAdd [1.0 teaspoon of baking soda] to the {blender}\nAdd [1.0 pinch of salt] to the {blender}\nBlend everything in a {blender} to a smooth mass with the consistency of thick cream\nPreheat the {frying pan}\nFry pancakes on both sides in a {frying pan} over medium heat
"""
//swiftlint:enable line_length

let parser: AlgorithmParsable = AlgorithmParser()
let algorithm = parser.parse(string: pancakes)

print("Ingredients")
print(algorithm.ingredients)
print("\nDependencies")
print(algorithm.dependencies)
print("\nSteps")
print(algorithm.steps)

//: [Next](@next)
