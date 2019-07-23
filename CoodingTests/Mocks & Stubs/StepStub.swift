//
//  Step.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 23/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
@testable import Core

extension Step {
    static func think() -> Step {
        return Step(description: "Think about starting cooking 🤔",
                    dependencies: [],
                    ingredients: [],
                    duration: nil)
    }
}
