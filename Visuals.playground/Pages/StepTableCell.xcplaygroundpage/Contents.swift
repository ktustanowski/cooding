//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Core

let think = "Think about starting cooking 🤔"
let thinkSomeMore = "Think about starting cooking for some time ⏱ 🤔"
let longThinkSomeMore = "Think about starting cooking for some time ⏱ 🤔 and then start over and then think about starting cooking"
let tenMinutes: TimeInterval = 60 * 10
let threeHours: TimeInterval = 60 * 60 * 3

/*:
 Simple Cell
 */
var simpleCell = StepTableCell.make()
simpleCell.viewModel = StepCellViewModel(step: Step(description: think))
/*:
 Simple Short Duration Cell
 */
var simpleShortDurationCell = StepTableCell.make()
simpleShortDurationCell.viewModel = StepCellViewModel(step: Step(description: thinkSomeMore,
                                                      duration: tenMinutes))
simpleShortDurationCell.frame.origin.y = simpleCell.top + 10
/*:
 Simple Long Duration Cell
 */
var simpleLongDurationCell = StepTableCell.make()
simpleLongDurationCell.viewModel = StepCellViewModel(step: Step(description: thinkSomeMore,
                                                             duration: threeHours))
simpleLongDurationCell.frame.origin.y = simpleShortDurationCell.top + 10
/*:
 Simple Long Duration Long Text Cell
 */
var simpleLongDurationAndTextCell = StepTableCell.make()
simpleLongDurationAndTextCell.viewModel = StepCellViewModel(step: Step(description: longThinkSomeMore,
                                                             duration: threeHours))
simpleLongDurationAndTextCell.frame.origin.y = simpleLongDurationCell.top + 10

let liveView = UIView(frame: .zero)
liveView.addSubview(simpleCell)
liveView.addSubview(simpleShortDurationCell)
liveView.addSubview(simpleLongDurationCell)
liveView.addSubview(simpleLongDurationAndTextCell)

liveView.frame.size.width = liveView.subviews.first?.frame.size.width ?? 0
liveView.frame.size.height = liveView.subviews.last!.top
PlaygroundPage.current.liveView = liveView

extension UIView {
    var top: CGFloat {
        return frame.origin.y + frame.size.height
    }
}

//: [Next](@next)
