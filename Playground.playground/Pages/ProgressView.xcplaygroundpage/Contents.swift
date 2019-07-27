//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Core

let progressView = ProgressView(frame: .zero)
progressView.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
progressView.heightAnchor.constraint(equalToConstant: 200),
progressView.widthAnchor.constraint(equalToConstant: 200)
    ])
progressView.backgroundColor = .red

PlaygroundPage.current.liveView = progressView
PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
