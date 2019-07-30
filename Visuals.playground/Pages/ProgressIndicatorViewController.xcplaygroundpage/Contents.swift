//: [Previous](@previous)
import UIKit
import PlaygroundSupport
import Core
import RxSwift
import RxRelay

var viewController = ProgressIndicatorViewController.make()
viewController.view.layoutIfNeeded()

PlaygroundPage.current.liveView = viewController.view
PlaygroundPage.current.needsIndefiniteExecution = true
//: [Next](@next)
