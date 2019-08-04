//
//  RecipeStubs.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import Core

//swiftlint:disable line_length
extension Recipe {
    private static var pancakesRaw: String {
        return #"""
        {
        "name":"Pancakes",
        "authorName":"Kamil Tustanowski",
        "authorURL":"https://www.linkedin.com/in/kamil-tustanowski-41498555",
        "imagesURL":[
        "https://cdn.pixabay.com/photo/2016/10/27/22/07/pancake-1776646_1280.jpg"
        ],
        "rawAlgorithm":":: version 0.1\nPrepare {blender}\nAdd [1.25 glass of buttermilk] to the {blender}\nAdd [0.25 glass of powdered sugar] to the {blender}\nAdd [1.0 heaping teaspoon of baking powder] to the {blender}\nAdd [1.0 teaspoon of baking soda] to the {blender}\nAdd [1.0 pinch of salt] to the {blender}\nBlend everything in a {blender} to a smooth mass with the consistency of thick cream\nPreheat the {frying pan}\nFry pancakes on both sides in a {frying pan} over medium heat",
        "time":1800,
        "people":3,
        "difficulty":"easy"
        }
        """#
    }
    
    static var pancakes: Recipe {
        //swiftlint:disable:next force_try
        return try! JSONDecoder().decode(Recipe.self, from: pancakesRaw.data(using: .utf8)!)
        
    }
}
//swiftlint:enable line_length
