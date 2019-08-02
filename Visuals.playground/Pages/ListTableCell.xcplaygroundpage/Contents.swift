//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Core

/*:
 Simple Cell
 */
var cell = ListTableCell.make()
cell.viewModel = ListCellViewModel(title: "Title text",
                                   description: "Description text")

PlaygroundPage.current.liveView = cell

//: [Next](@next)
