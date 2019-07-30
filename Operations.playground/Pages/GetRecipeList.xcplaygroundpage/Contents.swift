//: [Previous](@previous)

import Foundation
import UIKit
import PlaygroundSupport
import Core
import RxSwift

let disposeBag = DisposeBag()
let downloader = Downloader()

let recipeListURL = URL(string: "https://raw.githubusercontent.com/ktustanowski/cooding/master/Recipes/recipes_list.json")!
(downloader.download(url: recipeListURL) as? Observable<RecipeList>)?
    .subscribe(onNext: { list in
        print(list)
    },
               onError: { error in
                print(error)
    })
    .disposed(by: disposeBag)

PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
