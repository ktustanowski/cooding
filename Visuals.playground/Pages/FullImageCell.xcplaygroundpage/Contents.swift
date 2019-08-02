//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Core

/*:
 Simple Cell
 */
var cell = FullImageTableCell.make()
cell.viewModel = FullImageCellViewModel(title: "Title Text",
                                        imageURL: nil)

PlaygroundPage.current.liveView = cell

//: [Next](@next)
