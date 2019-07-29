//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport
import Core

let url = URL(string: "https://raw.githubusercontent.com/ktustanowski/cooding/master/Recipes/recipes_list.json")!

URLSession.shared.dataTask(with: url) { data, response, error in
    if let data = data {
        if let jsonString = String(data: data, encoding: .utf8) {
            print(jsonString)
            let recipe = try? JSONDecoder().decode([ShortRecipe].self, from: data)
            print(recipe)
        }
    }
    }.resume()




PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
