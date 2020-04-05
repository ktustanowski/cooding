//
//  FullImageTableCellSnapshotTests.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

import XCTest
@testable import Core
import SnapshotTesting

class FullImageTableCellSnapshotTests: XCTestCase {
    private var sut: FullImageTableCell!
    
    override func setUp() {
        super.setUp()
        sut = FullImageTableCell.make()
        sut.apply(theme: LightTheme())
    }
    
    func testInitialLook_WithTitle() {
        sut.viewModel = FullImageCellViewModel(title: "Pancakes", imageURL: nil)
        
        assertSnapshot(matching: sut, as: .image)
    }
    
    func testInitialLook_WithoutTitle() {
        sut.viewModel = FullImageCellViewModel(title: nil, imageURL: nil)
        
        assertSnapshot(matching: sut, as: .image)
    }
}
