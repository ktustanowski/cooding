//
//  AlgorithmParser.swift
//  Core
//
//  Created by Kamil Tustanowski on 29/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public protocol AlgorithmParsing {
    func parse(string: String) -> Algorithm
}

struct AlgorithmConstants {
    let ingredientsRegex = #"\[[\p{L}\p{M}\p{Nd}.,() ]+\]*"#
    let dependenciesRegex = #"\{[\p{L}\p{M}\p{Nd}., ]+\}*"#
    let durationRegex = #"\<[\p{Nd}.,]+\>*"#
    let ingredientStart = "["
    let ingredientEnd = "]"
    let dependencyStart = "{"
    let dependencyEnd = "}"
    let durationStart = "<"
    let durationEnd = ">"
    let configurationMark = "::"
}

public struct AlgorithmParser: AlgorithmParsing {
    private let constants = AlgorithmConstants()
    
    public func parse(string: String) -> Algorithm {
        let lines = string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "\n")
        
        let steps = lines.map { line -> Step? in //TODO: Check for memory leaks
            guard !line.contains(self.constants.configurationMark) else { return nil }
            
            let dependencies = self.matches(regex: self.constants.dependenciesRegex, in: line)
                .map { $0.trimm([self.constants.dependencyStart,
                                 self.constants.dependencyEnd]) }
                .map { Dependency(name: $0) }
            
            let ingredients = self.matches(regex: self.constants.ingredientsRegex, in: line)
                .map { $0.trimm([self.constants.ingredientStart,
                                 self.constants.ingredientEnd]) }
                .map { ingredientSubstring -> Ingredient? in
                    // TODO: Current approach doesn't support i.e. 1.25g
                    let quantityString = ingredientSubstring.components(separatedBy: " ").first ?? ""
                    guard let quantity = Double(quantityString) else { return nil }
                    
                    return Ingredient(name: ingredientSubstring.trimm(["\(quantityString) "]),
                                      quantity: quantity)
                }
                .compactMap { $0 }
            
            let durationString = self.matches(regex: self.constants.durationRegex, in: line).first ?? ""
            
            let trimmedDescription = line
                .replacingOccurrences(of: durationString, with: "")
                .trimm([self.constants.durationStart,
                        self.constants.durationEnd,
                        self.constants.ingredientStart,
                        self.constants.ingredientEnd,
                        self.constants.dependencyStart,
                        self.constants.dependencyEnd])
                .trimTrailingSpace()
            
            return Step(description: trimmedDescription,
                        dependencies: dependencies.isEmpty ? nil : dependencies.sorted(by: { $0.name < $1.name }),
                        ingredients: ingredients.isEmpty ? nil : ingredients.sorted(by: { $0.name < $1.name }),
                        duration: Double(durationString.trimm([self.constants.durationStart,
                                                               self.constants.durationEnd])))
            }
            .compactMap { $0 }
        
        let dependencies = steps.map { $0.dependencies }
            .compactMap { $0 }
            .flatMap { $0 }
        
        let dependenciesSet = Set<Dependency>(dependencies)
        
        let ingredients = steps.map { $0.ingredients }
            .compactMap { $0 }
            .flatMap { $0 }
        
        let ingredientsSet = Set<Ingredient>(ingredients)
        return Algorithm(ingredients: Array(ingredientsSet).sorted(by: { $0.name < $1.name }),
                         steps: steps,
                         dependencies: Array(dependenciesSet).sorted(by: { $0.name < $1.name }))
    }
    
    public init() {}
}

private extension AlgorithmParser {
    func matches(regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            assertionFailure("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
