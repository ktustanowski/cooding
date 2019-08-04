//: [Previous](@previous)

import Foundation
import Core
import PlaygroundSupport

let cell = ButtonTableCell.make()
cell.viewModel = ButtonCellViewModel(title: "Tap me!")
cell.apply(theme: DefaultTheme())

PlaygroundPage.current.liveView = cell

//: [Next](@next)
