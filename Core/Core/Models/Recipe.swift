//
//  Recipe.swift
//  Core
//
//  Created by Kamil Tustanowski on 23/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public enum Difficulty: String {
    case easy
    case medium
    case hard
    case impossible
}

public struct RawAlgorithm {
    public let raw: String
}

public extension RawAlgorithm {
    var parsed: Algorithm {
        // TODOKT: implement passing parsed algorithm!
        return Algorithm(ingredients: [], steps: [], dependencies: [])
    }
}

public struct Algorithm {
    public let ingredients: [Ingredient]
    public let steps: [Step]
    public let dependencies: [Dependency]
    
    public init(ingredients: [Ingredient], steps: [Step], dependencies: [Dependency]) {
        self.ingredients = ingredients
        self.steps = steps
        self.dependencies = dependencies
    }
}

public struct Ingredient {
    public let name: String
    public let quantity: Double
    
    public init(name: String, quantity: Double) {
        self.name = name
        self.quantity = quantity
    }
}

public struct Step {
    public let description: String
    public let dependencies: [Dependency]?
    public let ingredients: [Ingredient]?
    public let duration: TimeInterval?
    
    public init(description: String,
                dependencies: [Dependency]? = nil,
                ingredients: [Ingredient]? = nil,
                duration: TimeInterval? = nil) {
        self.description = description
        self.dependencies = dependencies
        self.ingredients = ingredients
        self.duration = duration
    }
}

public struct Dependency {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}

public struct Recipe {
    /// URL to author site
    public let author: URL
    /// URL to recipe in repository
    public let source: URL
    /// URL to original recipe - if available
    public let original: URL?
    /// Images of a recipe, cooking process etc.
    public let images: [URL]
    /// The unparsed recipe
    public let algorithm: RawAlgorithm
    /// How long does it take from start to finish
    public let time: TimeInterval
    /// How many people can eat the meal
    public let people: Int
    /// How hard is to cook thie recipe
    public let difficulty: Difficulty
    /// Fill when this is a traditional meal of some country
    public let country: String?
}
