//
//  StepTableCell.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 28/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import XCTest
@testable import Core
import SnapshotTesting

class StepTableCellSnapshotTests: XCTestCase {
    private var sut: StepTableCell!
    
    override func setUp() {
        super.setUp()
        sut = StepTableCell.make()
        sut.apply(theme: DefaultTheme())
    }
    
    func testShortDescriptionOnlyCell() {
        sut.viewModel = StepCellViewModel(step: Step(description: "Add 1.5 glass of water to pumpkin"))
        assertSnapshot(matching: sut, as: .image)
    }
    
    func testShortDescription_ShortDurationCell() {
        sut.viewModel = StepCellViewModel(step: Step(description: "Add 1.5 glass of water to pumpkin",
                                                     duration: .minutes(10)))
        assertSnapshot(matching: sut, as: .image)
    }

    func testShortDescription_LongDurationCell() {
        sut.viewModel = StepCellViewModel(step: Step(description: "Add 1.5 glass of water to pumpkin",
                                                     duration: .hours(3)))
        assertSnapshot(matching: sut, as: .image)
    }

    func testLongDescription_LongDurationCell() {
        sut.viewModel = StepCellViewModel(step: Step(description: .loremIpsumShort,
                                                     duration: .hours(3)))
        assertSnapshot(matching: sut, as: .image)
    }

    func testShortDescriptionOnlyCell_WhenDone() {
        sut.viewModel = StepCellViewModel(step: Step(description: "Add 1.5 glass of water to pumpkin"))
        sut.viewModel.input.doneButtonTapped()

        assertSnapshot(matching: sut, as: .image)
    }
    
    func testShortDescription_ShortDurationCell_WhenDone() {
        sut.viewModel = StepCellViewModel(step: Step(description: "Add 1.5 glass of water to pumpkin",
                                                     duration: .minutes(10)))
        sut.viewModel.input.doneButtonTapped()

        assertSnapshot(matching: sut, as: .image)
    }
    
    func testShortDescription_LongDurationCell_WhenDone() {
        sut.viewModel = StepCellViewModel(step: Step(description: "Add 1.5 glass of water to pumpkin",
                                                     duration: .hours(3)))
        
        sut.viewModel.input.doneButtonTapped()

        assertSnapshot(matching: sut, as: .image)
    }
    
    func testLongDescription_LongDurationCell_WhenDone() {
        sut.viewModel = StepCellViewModel(step: Step(description: .loremIpsumShort,
                                                     duration: .hours(3)))
        
        sut.viewModel.input.doneButtonTapped()

        assertSnapshot(matching: sut, as: .image)
    }
}
