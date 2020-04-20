//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Core

let imageURL = URL(string: "https://cdn.pixabay.com/photo/2016/10/27/22/07/pancake-1776646_1280.jpg")!

/*:
 Image with text
 */
var imageAndTextCell = FullImageTableCell.make()
imageAndTextCell.apply(theme: DarkTheme())
imageAndTextCell.viewModel = FullImageCellViewModel(title: "Title Text",
                                        imageURL: imageURL)

var imageAndTextCellLight = FullImageTableCell.make()
imageAndTextCellLight.apply(theme: LightTheme())
imageAndTextCellLight.viewModel = FullImageCellViewModel(title: "Title Text",
                                        imageURL: imageURL)

/*:
 Image only
 */
var imageCell = FullImageTableCell.make()
imageCell.apply(theme: DarkTheme())
imageCell.viewModel = FullImageCellViewModel(title: nil,
                                        imageURL: imageURL)

let liveView = UIStackView(arrangedSubviews: [imageAndTextCell.contentView,
                                              imageAndTextCellLight.contentView,
                                              imageCell.contentView])
liveView.distribution = .fillEqually
liveView.axis = .vertical
liveView.frame = imageCell.frame
liveView.frame.size.height = 3 * liveView.frame.height

PlaygroundPage.current.liveView = liveView
PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
