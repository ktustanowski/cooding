//: [Previous](@previous)

import Foundation
import Core
import PlaygroundSupport

let cell = SliderTableCell.make()
cell.viewModel = SliderCellViewModel(title: "Slider cell text", minimum: 1, maximum: 15)
cell.viewModel.value.subscribe { print("Value did change to: \($0)") }

let theme = LightTheme()

cell.apply(theme: theme)
cell.backgroundColor = theme.primary

PlaygroundPage.current.liveView = cell

//: [Next](@next)
