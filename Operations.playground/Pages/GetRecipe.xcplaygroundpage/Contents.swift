//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport
import Core
import RxSwift

let disposeBag = DisposeBag()
let downloader = Downloader()

let pancakesRecipeURL = URL(string: "https://raw.githubusercontent.com/ktustanowski/recipes/master/pancakes.json")!
(downloader.download(url: pancakesRecipeURL) as? Observable<Recipe>)?
    .subscribe(onNext: { recipe in
        print(recipe)
    },
               onError: { error in
                print(error)
    })
    .disposed(by: disposeBag)

PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
