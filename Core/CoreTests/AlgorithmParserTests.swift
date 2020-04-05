//
//  RawAlgorithmTests.swift
//  CoreTests
//
//  Created by Kamil Tustanowski on 28/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import XCTest
@testable import Core

class AlgorithmParserTests: XCTestCase {
    private var sut: AlgorithmParsing!
    override func setUp() {
        sut = AlgorithmParser()
    }
    
    func testParsingStep_WithoutIngredientsOrDependencies() {
        let step = "Do something"
        
        let algorithm = sut.parse(string: step)
        
        XCTAssertEqual(algorithm.dependencies, [])
        XCTAssertEqual(algorithm.ingredients, [])
        XCTAssertEqual(algorithm.steps.count, 1)
        XCTAssertEqual(algorithm.steps.first, Step(description: "Do something",
                                                   dependencies: nil,
                                                   ingredients: nil,
                                                   duration: nil))
    }

    func testParsingStep_WithoutIngredientsOrDependencies_ButWithDuration() {
        let step = "Do something <72.0>"
        
        let algorithm = sut.parse(string: step)
        
        XCTAssertEqual(algorithm.dependencies, [])
        XCTAssertEqual(algorithm.ingredients, [])
        XCTAssertEqual(algorithm.steps.count, 1)
        XCTAssertEqual(algorithm.steps.first, Step(description: "Do something ",
                                                   dependencies: nil,
                                                   ingredients: nil,
                                                   duration: 72.0))
    }

    func testParsingStep_WithDependency_WithoutIngredients() {
        let step = "Do something with {frying pan}"
        
        let algorithm = sut.parse(string: step)
        
        XCTAssertEqual(algorithm.dependencies, [Dependency(name: "frying pan")])
        XCTAssertEqual(algorithm.ingredients, [])
        XCTAssertEqual(algorithm.steps.count, 1)
        XCTAssertEqual(algorithm.steps.first, Step(description: "Do something with frying pan",
                                                   dependencies: [Dependency(name: "frying pan")],
                                                   ingredients: nil,
                                                   duration: nil))
    }

    func testParsingStep_WithDependencyAndIngredient() {
        let step = "Do something with [1.0 sausage] and {frying pan}"
        
        let algorithm = sut.parse(string: step)
        
        XCTAssertEqual(algorithm.dependencies, [Dependency(name: "frying pan")])
        XCTAssertEqual(algorithm.ingredients, [Ingredient(name: "sausage", quantity: 1.0)])
        XCTAssertEqual(algorithm.steps.count, 1)
        XCTAssertEqual(algorithm.steps.first, Step(description: "Do something with 1.0 sausage and frying pan",
                                                   dependencies: [Dependency(name: "frying pan")],
                                                   ingredients: [Ingredient(name: "sausage", quantity: 1.0)],
                                                   duration: nil))
    }

    func testParsingStep_WithDependencyAndIngredient_DontSumTheSameIngredients() {
        let steps = "Do something with [1.0 sausage] and {frying pan}\nDo additional something to this [1.0 sausage] and {frying pan}"
        
        let algorithm = sut.parse(string: steps)
        
        XCTAssertEqual(algorithm.dependencies, [Dependency(name: "frying pan")])
        XCTAssertEqual(algorithm.ingredients, [Ingredient(name: "sausage", quantity: 1.0)])
        XCTAssertEqual(algorithm.steps.count, 2)
        XCTAssertEqual(algorithm.steps.first, Step(description: "Do something with 1.0 sausage and frying pan",
                                                   dependencies: [Dependency(name: "frying pan")],
                                                   ingredients: [Ingredient(name: "sausage", quantity: 1.0)],
                                                   duration: nil))
        XCTAssertEqual(algorithm.steps.last, Step(description: "Do additional something to this 1.0 sausage and frying pan",
                                                  dependencies: [Dependency(name: "frying pan")],
                                                  ingredients: [Ingredient(name: "sausage", quantity: 1.0)],
                                                  duration: nil))

    }

    func testParsingStep_WithDependenciesAndIngredients() {
        let step = "Do something with [1.0 sausage] [2.0 pickles] {frying pan} and {blender}"
        
        let algorithm = sut.parse(string: step)
        
        XCTAssertEqual(algorithm.dependencies, [Dependency(name: "blender"),
                                                Dependency(name: "frying pan")])
        XCTAssertEqual(algorithm.ingredients, [Ingredient(name: "pickles", quantity: 2.0),
                                               Ingredient(name: "sausage", quantity: 1.0)])
        XCTAssertEqual(algorithm.steps.count, 1)
        XCTAssertEqual(algorithm.steps.first, Step(description: "Do something with 1.0 sausage 2.0 pickles frying pan and blender",
                                                   dependencies: [Dependency(name: "blender"),
                                                                  Dependency(name: "frying pan")],
                                                   ingredients: [Ingredient(name: "pickles", quantity: 2.0),
                                                                 Ingredient(name: "sausage", quantity: 1.0)],
                                                   duration: nil))
    }

    func testParseAlgorithm() {
        //swiftlint:disable line_length
        let pancakes = """
:: version 0.1\nPrepare {blender}\nAdd [1.25 glass of buttermilk] to the {blender}\nAdd [0.25 glass of powdered sugar] to the {blender}\nAdd [1.0 heaping teaspoon of baking powder] to the {blender}\nAdd [1.0 teaspoon of baking soda] to the {blender}\nAdd [1.0 pinch of salt] to the {blender}\nBlend everything in a {blender} to a smooth mass with the consistency of thick cream\nPreheat the {frying pan}\nFry pancakes on both sides in a {frying pan} over medium heat <900>
"""
        ////swiftlint:enable line_length

        let algorithm = sut.parse(string: pancakes)
        
        let ingredients = [Ingredient(name: "glass of buttermilk", quantity: 1.25),
                           Ingredient(name: "glass of powdered sugar", quantity: 0.25),
                           Ingredient(name: "heaping teaspoon of baking powder", quantity: 1.0),
                           Ingredient(name: "pinch of salt", quantity: 1.0),
                           Ingredient(name: "teaspoon of baking soda", quantity: 1.0)]
        
        let dependencies = [Dependency(name: "blender"),
                             Dependency(name: "frying pan")]
        
        //swiftlint:disable line_length
        let steps = [Step(description: "Prepare blender", dependencies: Optional([Dependency(name: "blender")]), ingredients: nil, duration: nil),
                      Step(description: "Add 1.25 glass of buttermilk to the blender", dependencies: Optional([Dependency(name: "blender")]), ingredients: Optional([Ingredient(name: "glass of buttermilk", quantity: 1.25)]), duration: nil),
                      Step(description: "Add 0.25 glass of powdered sugar to the blender", dependencies: Optional([Dependency(name: "blender")]), ingredients: Optional([Ingredient(name: "glass of powdered sugar", quantity: 0.25)]), duration: nil),
                      Step(description: "Add 1.0 heaping teaspoon of baking powder to the blender", dependencies: Optional([Dependency(name: "blender")]), ingredients: Optional([Ingredient(name: "heaping teaspoon of baking powder", quantity: 1.0)]), duration: nil),
                      Step(description: "Add 1.0 teaspoon of baking soda to the blender", dependencies: Optional([Dependency(name: "blender")]), ingredients: Optional([Ingredient(name: "teaspoon of baking soda", quantity: 1.0)]), duration: nil),
                      Step(description: "Add 1.0 pinch of salt to the blender", dependencies: Optional([Dependency(name: "blender")]), ingredients: Optional([Ingredient(name: "pinch of salt", quantity: 1.0)]), duration: nil),
                      Step(description: "Blend everything in a blender to a smooth mass with the consistency of thick cream", dependencies: Optional([Dependency(name: "blender")]), ingredients: nil, duration: nil),
                      Step(description: "Preheat the frying pan", dependencies: Optional([Dependency(name: "frying pan")]), ingredients: nil, duration: nil),
                      Step(description: "Fry pancakes on both sides in a frying pan over medium heat ", dependencies: Optional([Dependency(name: "frying pan")]), ingredients: nil, duration: Optional(900.0))]
        //swiftlint:enable line_length
        
        XCTAssertEqual(algorithm.ingredients, ingredients)
        XCTAssertEqual(algorithm.dependencies, dependencies)
        XCTAssertEqual(algorithm.steps, steps)
    }
}
