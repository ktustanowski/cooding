//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Core

let think = "Think about starting cooking 🤔"
let thinkSomeMore = "Think about starting cooking for some time ⏱ 🤔"
let longThinkSomeMore = "Think about starting cooking for some time ⏱ 🤔 and then start over and then think about starting cooking"
let tenSeconds: TimeInterval = 10
let threeHours: TimeInterval = 60 * 60 * 3

/*:
 Simple Cell
 */
var simpleCell = StepTableCell.make()
simpleCell.apply(theme: DarkTheme())
simpleCell.viewModel = StepCellViewModel(step: Step(description: think))
/*:
 Simple Short Duration Cell
 */
var simpleShortDurationCell = StepTableCell.make()
simpleShortDurationCell.apply(theme: LightTheme())
simpleShortDurationCell.viewModel = StepCellViewModel(step: Step(description: thinkSomeMore,
                                                      duration: tenSeconds))
/*:
 Simple Long Duration Cell
 */
var simpleLongDurationCell = StepTableCell.make()
simpleLongDurationCell.apply(theme: DarkTheme())
simpleLongDurationCell.viewModel = StepCellViewModel(step: Step(description: thinkSomeMore,
                                                             duration: threeHours))
/*:
 Simple Long Duration Long Text Cell
 */
var simpleLongDurationAndTextCell = StepTableCell.make()
simpleLongDurationAndTextCell.apply(theme: LightTheme())
simpleLongDurationAndTextCell.viewModel = StepCellViewModel(step: Step(description: longThinkSomeMore,
                                                             duration: threeHours))

let liveView = UIStackView(arrangedSubviews: [simpleCell.contentView,
                                              simpleShortDurationCell.contentView,
                                              simpleLongDurationCell.contentView,
                                              simpleLongDurationAndTextCell.contentView])
liveView.distribution = .fillEqually
liveView.axis = .vertical
liveView.frame = simpleLongDurationAndTextCell.frame
liveView.frame.size.height = 4 * liveView.frame.height

PlaygroundPage.current.liveView = liveView

//: [Next](@next)
