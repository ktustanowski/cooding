//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Core

let imageURL = URL(string: "https://cdn.pixabay.com/photo/2016/10/27/22/07/pancake-1776646_1280.jpg")!

/*:
 Image with text
 */
var imageAndTextCell = FullImageTableCell.make()
imageAndTextCell.apply(theme: DefaultTheme())
imageAndTextCell.viewModel = FullImageCellViewModel(title: "Title Text",
                                        imageURL: imageURL)

var imageCell = FullImageTableCell.make()
imageCell.apply(theme: DefaultTheme())
imageCell.viewModel = FullImageCellViewModel(title: nil,
                                        imageURL: imageURL)
imageCell.frame.origin.y = imageAndTextCell.top + 10

let liveView = UIView(frame: .zero)
liveView.addSubview(imageAndTextCell)
liveView.addSubview(imageCell)

liveView.frame.size.width = liveView.subviews.first?.frame.size.width ?? 0
liveView.frame.size.height = liveView.subviews.last!.top

PlaygroundPage.current.liveView = liveView
PlaygroundPage.current.needsIndefiniteExecution = true

extension UIView {
    var top: CGFloat {
        return frame.origin.y + frame.size.height
    }
}

//: [Next](@next)
