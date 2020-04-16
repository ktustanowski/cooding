//: [Previous](@previous)

import PlaygroundSupport
import Foundation
import Core
//swiftlint:disable line_length
let pancakes = """
:: version 0.1\nPrepare {blender}\nAdd [1.25 glass of buttermilk] to the {blender}\nAdd [0.25 glass of powdered sugar] to the {blender}\nAdd [1.0 heaping teaspoon of baking powder] to the {blender}\nAdd [1.0 teaspoon of baking soda] to the {blender}\nAdd [1.0 pinch of salt] to the {blender}\nBlend everything in a {blender} to a smooth mass with the consistency of thick cream\nPreheat the {frying pan}\nFry pancakes on both sides in a {frying pan} over medium heat
"""
//swiftlint:enable line_length

let parser: AlgorithmParsing = AlgorithmParser()
let algorithm = parser.parse(string: pancakes)

print("Ingredients")
print(algorithm.ingredients)
print("\nDependencies")
print(algorithm.dependencies)
print("\nSteps")
print(algorithm.steps)

func matches(regex: String, in text: String) -> [String] {
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

let step = parser.parse(string: "Dodaj [2ą żźćńółęąśŻŹĆĄŚĘŁÓŃ] into {frying pan} <60>\n")
let ingredient = matches(regex: #"\[[\p{L}\p{M}\p{Nd}.,() ]+\]*"#, in: "Do something with [1.0g of sausage] and {frying pan}")
let ingredientWithPolishCharacters = matches(regex: #"\[[\p{L}\p{M}\p{Nd}.,() ]+\]*"#, in: "Dodaj [2ą żźćńółęąśŻŹĆĄŚĘŁÓŃ]")

PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
