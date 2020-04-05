//
//  ProgressIndicatorViewControllerSnapshotTests.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import XCTest
@testable import Core
import SnapshotTesting

//swiftlint:disable:next type_name
class ProgressIndicatorViewControllerSnapshotTests: XCTestCase {
    private var sut: ProgressIndicatorViewController!
    
    override func setUp() {
        super.setUp()
        sut = ProgressIndicatorViewController.make()
        sut.loadViewIfNeeded()
        sut.apply(theme: LightTheme())
    }
    
    func testInitialLook() {
        defaultDevices.forEach { device in
            assertSnapshot(matching: sut, as: Snapshotting.image(on: device))
        }
    }
}
