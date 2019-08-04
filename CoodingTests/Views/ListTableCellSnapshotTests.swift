//
//  ListTableCellSnapshotTests.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

import XCTest
@testable import Core
import SnapshotTesting

class ListTableCellSnapshotTests: XCTestCase {
    private var sut: ListTableCell!
    
    override func setUp() {
        super.setUp()
        sut = ListTableCell.make()
        sut.apply(theme: DefaultTheme())
    }
    
    func testInitialLook() {
        //swiftlint:disable:next line_length
        sut.viewModel = ListCellViewModel(title: "99999 Ingredients", description: "• 1.0 of something\n• 1.0 of something\n• 1.0 of something\n• 1.0 of something\n• 1.0 of something")
        sut.frame.size.height = 180
        
        assertSnapshot(matching: sut, as: .image)
    }
}
