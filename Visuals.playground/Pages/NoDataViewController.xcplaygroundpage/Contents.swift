//: [Previous](@previous)
import UIKit
import PlaygroundSupport
import Core
import RxSwift
import RxRelay

let noRetry = NoDataViewModel(title: "Sorry!",
                              message: "This data is not available...",
                              isRetryAvailable: false)

let retryAvailable = NoDataViewModel(title: "Sorry!",
                              message: "Something went wrong while loading data.",
                              isRetryAvailable: true)

var viewController = NoDataViewController.make()
viewController.viewModel = noRetry
//viewController.viewModel = retryAvailable
viewController.loadViewIfNeeded()

let disposeBag = DisposeBag()
viewController.viewModel.output.didTapRetry
    .subscribe(onNext: { print("Retry Tapped!") })
    .disposed(by: disposeBag)

PlaygroundPage.current.liveView = viewController.view
PlaygroundPage.current.needsIndefiniteExecution = true
//: [Next](@next)
