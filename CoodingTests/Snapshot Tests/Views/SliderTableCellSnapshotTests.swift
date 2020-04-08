//
//  SliderTableCellSnapshotTests.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 13/11/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

import XCTest
@testable import Core
import SnapshotTesting

class SliderTableCellSnapshotTests: XCTestCase {
    private var sut: SliderTableCell!
    
    override func setUp() {
        super.setUp()
        sut = SliderTableCell.make()
        sut.apply(theme: LightTheme())
        sut.titleLabel.text = nil
    }
    
    func testInitialLook() {
        sut.viewModel = SliderCellViewModel(minimum: 1, maximum: 10)
        
        assertSnapshot(matching: sut, as: .image)
    }
    
    func testInitialLook_WithInitialValue() {
        sut.viewModel = SliderCellViewModel(minimum: 1, maximum: 10, value: 5)
        
        assertSnapshot(matching: sut, as: .image)
    }

    func testInitialLook_WithTitle() {
        sut.viewModel = SliderCellViewModel(minimum: 1, maximum: 10)
        sut.titleLabel.text = "Slider cell title"
        
        assertSnapshot(matching: sut, as: .image)
    }
}
