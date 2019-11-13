//: [Previous](@previous)

import Foundation
import Core
import PlaygroundSupport

let cell = SliderTableCell.make()
cell.viewModel = SliderCellViewModel(minimum: 1, maximum: 15)
cell.viewModel.value.subscribe { print("Value did change to: \($0)") }
cell.apply(theme: DefaultTheme())
cell.backgroundColor = .white

PlaygroundPage.current.liveView = cell

//: [Next](@next)
