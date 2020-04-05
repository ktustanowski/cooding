//
//  SuccessViewControllerSnapshotTests.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import XCTest
@testable import Core
import SnapshotTesting

class SuccessViewControllerSnapshotTests: XCTestCase {
    private var sut: SuccessViewController!
    
    override func setUp() {
        super.setUp()
        sut = SuccessViewController.make()
        sut.viewModel = SuccessViewModel(title: "Enjoy!",
                                         imageName: "meal")
        sut.loadViewIfNeeded()
        sut.apply(theme: LightTheme())
    }
    
    func testInitialLook() {
        defaultDevices.forEach { device in
            assertSnapshot(matching: sut, as: Snapshotting.image(on: device))
        }
    }
}
