//
//  CookingViewControllerSnapshotTests.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 23/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import XCTest
@testable import Core
import SnapshotTesting

class CookingViewControllerSnapshotTests: XCTestCase {
    private var sut: CookingViewController!
    
    override func setUp() {
        super.setUp()
        sut = CookingViewController()
    }

    func testInitialLook() {
        sut.viewModel = CookingViewModel(algorithm: Algorithm(ingredients: [], steps: RecipeFactory.pancakes(), dependencies: []))
        sut.loadViewIfNeeded()
        sut.apply(theme: LightTheme())

        defaultDevices.forEach { device in
            assertSnapshot(matching: sut, as: Snapshotting.image(on: device))
        }
    }
    
    func testInitialLook_VeryLongDescriptions() {
        sut.viewModel = CookingViewModel(algorithm: Algorithm(ingredients: [], steps: RecipeFactory.veryLongDescriptions(), dependencies: []))
        sut.loadViewIfNeeded()
        sut.apply(theme: LightTheme())
        
        defaultDevices.forEach { device in
            assertSnapshot(matching: sut, as: Snapshotting.image(on: device))
        }
    }
}
