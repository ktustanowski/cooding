//
//  Recipe.swift
//  Core
//
//  Created by Kamil Tustanowski on 23/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

//TODO: Move models to separate files
public enum Difficulty: String, Codable {
    case easy
    case medium
    case hard
    case impossible
    
    enum Key: CodingKey {
        case rawValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        guard let difficulty = Difficulty(rawValue: rawValue) else { throw DownloadError.corruptedData }
        self = difficulty
    }
}

public struct Algorithm: Equatable {
    public let ingredients: [Ingredient]
    public let steps: [Step]
    public let dependencies: [Dependency]
    
    public init(ingredients: [Ingredient], steps: [Step], dependencies: [Dependency]) {
        self.ingredients = ingredients
        self.steps = steps
        self.dependencies = dependencies
    }
}

public struct Ingredient: Equatable, Hashable {
    public let name: String
    public let quantity: Double
    
    public init(name: String, quantity: Double) {
        self.name = name
        self.quantity = quantity
    }
}

extension Ingredient {
    var formatted: String {
        return "\(quantity) \(name)"
    }
    
    func format(multiplier: Float) -> String {
        return "\(String(format: "%.2f", quantity * Double(multiplier))) \(name)"
    }
}

public struct Step: Equatable, Hashable {
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

public struct Dependency: Equatable, Hashable {
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}

public struct RecipeList: Codable, Equatable {
    /// Recipe list
    public let recipes: [ShortRecipe]
    
    public init(recipes: [ShortRecipe]) {
        self.recipes = recipes
    }
}

public struct ShortRecipe: Codable, Equatable {
    /// Recipe name
    public let name: String
    /// URL to recipe
    public let sourceURL: URL
    /// Images of a recipe, cooking process etc.
    public let imageURL: URL?
    
    public init(name: String, sourceURL: URL, imageURL: URL?) {
        self.name = name
        self.sourceURL = sourceURL
        self.imageURL = imageURL
    }
}

public struct Recipe: Codable, Equatable {
    /// Recipe name
    public var name: String
    /// URL to author site
    public let authorName: String?
    /// URL to author site
    public let authorURL: URL?
    /// URL to original recipe - if available
    public let originalSourceURL: URL?
    /// Images of a recipe, cooking process etc. - for now only first is used
    public let imagesURL: [URL]?
    /// The unparsed recipe
    public let rawAlgorithm: String
    /// How long does it take from start to finish - in seconds
    public let time: TimeInterval?
    /// How many people can eat the meal
    public let people: Int
    /// How hard is to cook thie recipe
    public let difficulty: Difficulty
    /// Fill when this is a traditional meal of some country
    public let country: String?
        
    public init(name: String,
                authorName: String?,
                authorURL: URL?,
                originalSourceURL: URL?,
                imagesURL: [URL]?,
                rawAlgorithm: String,
                time: TimeInterval?,
                people: Int = 1,
                difficulty: Difficulty,
                country: String?) {
        self.name = name
        self.authorName = authorName
        self.authorURL = authorURL
        self.originalSourceURL = originalSourceURL
        self.imagesURL = imagesURL
        self.rawAlgorithm = rawAlgorithm
        self.time = time
        self.people = people
        self.difficulty = difficulty
        self.country = country
    }
}

public extension Recipe {
    
    /// Use to export recipes to a repository
    var repositoryJSON: String {
        var output = "{\n"

        output += "\"name\": \"\(name)\",\n"

        if let authorName = authorName {
            output += "\"authorName\": \"\(authorName)\",\n"
        }

        if let authorURL = authorURL {
            output += "\"authorURL\": \"\(authorURL.absoluteString)\",\n"
        }

        if let originalSourceURL = originalSourceURL {
            output += "\"originalSourceURL\": \"\(originalSourceURL.absoluteString)\",\n"
        }

        if let imageURL = imagesURL?.first {
            output += "\"imagesURL\": [\"\(imageURL.absoluteString)\"],\n"
        }

        let rawSteps = rawAlgorithm.components(separatedBy: "\n")
        let rawAlgorithmUpdated = rawSteps.joined(separator: "\\n")

        output += "\"rawAlgorithm\": \"\(rawAlgorithmUpdated)\",\n"

        if let time = time {
            output += "\"time\": \(time),\n"
        }

        output += "\"people\": \(people),\n"

        if let country = country {
            output += "\"country\": \"\(country)\",\n"
        }

        output += "\"difficulty\": \"\(difficulty.rawValue)\"\n"

        output += "}"
        
        return output
    }
}
