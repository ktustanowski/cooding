//: [Previous](@previous)
import UIKit
import PlaygroundSupport
import Core
import RxSwift
import RxRelay

var viewController = ProgressIndicatorViewController.make()
viewController.apply(theme: DefaultTheme())
viewController.loadViewIfNeeded()

PlaygroundPage.current.liveView = viewController.view
PlaygroundPage.current.needsIndefiniteExecution = true
//: [Next](@next)
