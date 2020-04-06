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
// Uncomment to check this screen with retry capabilities
//viewController.viewModel = retryAvailable

let disposeBag = DisposeBag()
viewController.viewModel.output.didTapRetry
    .subscribe(onNext: { print("Retry Tapped!") })
    .disposed(by: disposeBag)

let (parent, _) = playgroundControllers(device: .phone47inch,
                                        child: viewController)

PlaygroundPage.current.liveView = parent
viewController.apply(theme: DarkTheme())

//: [Next](@next)
