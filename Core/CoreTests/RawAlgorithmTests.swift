//
//  RawAlgorithmTests.swift
//  CoreTests
//
//  Created by Kamil Tustanowski on 28/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import XCTest
@testable import Core

class RawAlgorithmTests: XCTestCase {
    private var sut: RawAlgorithm!
    
    func testRawAlgorithmParsesToAlgorithm() {
        sut = RawAlgorithm(raw: "")
        let algorithm = sut.parsed
        
        let dependencies = [Dependency(name: "blender"),
                            Dependency(name: "frying pan")]
        
        let ingredients = [Ingredient(name: "glass off buttermilk", quantity: 1.25),
                           Ingredient(name: "glass of powdered sugar", quantity: 0.25),
                           Ingredient(name: "heaping teaspoon of baking powder", quantity: 1.0),
                           Ingredient(name: "teaspoon of baking soda", quantity: 1.0),
                           Ingredient(name: "pinch of salt", quantity: 1.0)]
        
        XCTAssertEqual(algorithm.dependencies, dependencies.sorted(by: { $0.name < $1.name }))
        XCTAssertEqual(algorithm.ingredients, ingredients.sorted(by: { $0.name < $1.name }))
        XCTAssertEqual(algorithm.steps, RecipeFactory.pancakes())
    }
}
