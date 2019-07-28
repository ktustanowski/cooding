//
//  RecipeFactory.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 28/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
@testable import Core

struct RecipeFactory {
    static func pancakes() -> [Step] {
        return [Step(description: "Prepare blender",
                     dependencies: [Dependency(name: "blender")],
                     ingredients: nil, duration: .minutes(59)),
                Step(description: "Add 1.25 glass of buttermilk to the blender",
                     dependencies: [Dependency(name: "Blender")],
                     ingredients: [Ingredient(name: "glass off buttermilk", quantity: 1.25)]),
                Step(description: "Add 0.25 glass of powdered sugar to the blender",
                     dependencies: [Dependency(name: "blender")],
                     ingredients: [Ingredient(name: "szklanki cukru", quantity: 0.25)]),
                Step(description: "Add 1 heaping teaspoon of baking powder to the blender",
                     dependencies: [Dependency(name: "Blender")],
                     ingredients: [Ingredient(name: "heaping teaspoon of baking powder", quantity: 1.0)]),
                Step(description: "Add 1 teaspoon of baking soda to the blender",
                     dependencies: [Dependency(name: "blender")],
                     ingredients: [Ingredient(name: "1 teaspoon of baking soda", quantity: 1.0)], duration: .minutes(2)),
                Step(description: "Add 1 pinch of salt to the blender",
                     dependencies: [Dependency(name: "blender")],
                     ingredients: [Ingredient(name: "pinch of salt", quantity: 1.0)]),
                Step(description: "Blend everything in a blender to a smooth mass with the consistency of thick cream",
                     dependencies: [Dependency(name: "blender")]),
                Step(description: "Preheat the frying pan",
                     dependencies: [Dependency(name: "frying pan")]),
                Step(description: "Fry pancakes on both sides in a frying pan over medium heat",
                     dependencies: [Dependency(name: "frying pan")], duration: 256.0),
                Step(description: "#Add 1 teaspoon of baking soda to the blender",
                     dependencies: [Dependency(name: "blender")],
                     ingredients: [Ingredient(name: "1 teaspoon of baking soda", quantity: 1.0)], duration: .minutes(4)),
                Step(description: "#Add 1 pinch of salt to the blender",
                     dependencies: [Dependency(name: "blender")],
                     ingredients: [Ingredient(name: "pinch of salt", quantity: 1.0)]),
                Step(description: "#Blend everything in a blender to a smooth mass with the consistency of thick cream",
                     dependencies: [Dependency(name: "blender")]),
                Step(description: "#Preheat the frying pan",
                     dependencies: [Dependency(name: "frying pan")]),
                Step(description: "#Fry pancakes on both sides in a frying pan over medium heat",
                     dependencies: [Dependency(name: "frying pan")], duration: .hours(3))]
    }
    
    static func veryLongDescriptions() -> [Step] {
        return [Step(description: .loremIpsumLong,
                     dependencies: [Dependency(name: "frying pan")], duration: .hours(3)),
                Step(description: .loremIpsumMedium,
                     dependencies: [Dependency(name: "frying pan")], duration: .hours(3))]
    }
}
