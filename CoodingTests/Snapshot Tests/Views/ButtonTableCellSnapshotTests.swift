//
//  ButtonTableCell.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

import XCTest
@testable import Core
import SnapshotTesting

class ButtonTableCellSnapshotTests: XCTestCase {
    private var sut: ButtonTableCell!
    
    override func setUp() {
        super.setUp()
        sut = ButtonTableCell.make()
        sut.apply(theme: DefaultTheme())
    }
    
    func testInitialLook_WithTitle() {
        sut.viewModel = ButtonCellViewModel(title: "Start cooking")
        
        assertSnapshot(matching: sut, as: .image)
    }
}
