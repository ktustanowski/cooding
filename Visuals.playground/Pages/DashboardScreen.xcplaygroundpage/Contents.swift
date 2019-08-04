//: [Previous](@previous)

import UIKit
import PlaygroundSupport
import Core
import RxSwift
import RxRelay

var viewController = DashboardTabBarController()
viewController.viewModel = DashboardViewModel()

let (parent, _) = playgroundControllers(device: .phone47inch,
                                        child: viewController)

PlaygroundPage.current.liveView = parent
viewController.apply(theme: DefaultTheme())

//: [Next](@next)
