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
        sut.viewModel = CookingViewModel(algorithm: Algorithm(ingredients: [], steps: [.think()], dependencies: []))
        sut.loadViewIfNeeded()
    }

    func testInitialLook() {
        assertSnapshot(matching: sut, as: .image)
    }
}
