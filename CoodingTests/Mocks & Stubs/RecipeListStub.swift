//
//  RecipeListStub.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
@testable import Core

extension RecipeList {
    private static var listRaw: String {
        return #"""
        {
        "recipes":[
        {
        "name":"Pancakes",
        "sourceURL":"https://raw.githubusercontent.com/ktustanowski/recipes/master/pancakes.json",
        "imageURL":"http://google.com"
        },
        {
        "name":"Scrabbled Eggs",
        "sourceURL":"https://raw.githubusercontent.com/ktustanowski/recipes/master/pancakes-debug.json",
        "imageURL":"http://google.com"
        },
        {
        "name":"Ratatouille Eggs",
        "sourceURL":"https://raw.githubusercontent.com/ktustanowski/recipes/master/pancakes-debug.json",
        "imageURL":"http://google.com"
        }
        ]
        }
        """#
    }
    
    static var `default`: RecipeList {
        //swiftlint:disable:next force_try
        return try! JSONDecoder().decode(RecipeList.self, from: listRaw.data(using: .utf8)!)
    }
}
