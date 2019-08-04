//: [Previous](@previous)

import PlaygroundSupport
import Foundation
import Core

var viewController = SuccessViewController.make()
viewController.viewModel = SuccessViewModel(title: "Enjoy!", imageName: "meal")
viewController.loadViewIfNeeded()
viewController.apply(theme: DefaultTheme())

PlaygroundPage.current.liveView = viewController.view
PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
