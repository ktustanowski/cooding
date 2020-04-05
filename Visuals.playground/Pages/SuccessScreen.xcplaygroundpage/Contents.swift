//: [Previous](@previous)

import PlaygroundSupport
import Foundation
import Core

var viewController = SuccessViewController.make()
viewController.viewModel = SuccessViewModel(title: "Enjoy!", imageName: "meal")

let (parent, _) = playgroundControllers(device: .phone47inch,
                                        child: viewController)

PlaygroundPage.current.liveView = parent
viewController.apply(theme: DarkTheme())

//: [Next](@next)
