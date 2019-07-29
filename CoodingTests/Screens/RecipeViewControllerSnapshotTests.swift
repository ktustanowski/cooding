//
//  RecipeViewControllerSNapshotTests.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 28/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import XCTest
@testable import Core
import SnapshotTesting

class RecipeViewControllerSnapshotTests: XCTestCase {
    private var sut: RecipeViewController!
    
    override func setUp() {
        super.setUp()
        sut = RecipeViewController()
    }
    
    func testInitialLook() {
        sut.loadViewIfNeeded()
        
        defaultDevices.forEach { device in
            assertSnapshot(matching: sut, as: Snapshotting.image(on: device))
        }
    }
}
