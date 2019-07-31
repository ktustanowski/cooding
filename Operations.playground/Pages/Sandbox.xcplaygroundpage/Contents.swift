//: [Previous](@previous)

import Foundation
import Core
import RxSwift
import RxRelay
import RxDataSources
import PlaygroundSupport

// Test code here

let bag = DisposeBag()

let relay = PublishRelay<String>()
relay.debug("Relay")

let addRelay = PublishRelay<String>()
addRelay.debug("AddRelay")

relay.asObservable()
    .debug("Observable")
    .subscribe { txt in
    print(txt)
}.disposed(by: bag)

//addRelay.bind(to: relay)

addRelay.subscribe { print($0) }.disposed(by: bag)
relay.asObservable().bind(to: addRelay).disposed(by: bag)
relay.accept("3")



relay.accept("1")
addRelay.accept("2")

let observable = Observable<String>.create { observer -> Disposable in
    
    observer.onNext("10")
    observer.onCompleted()
    
    return Disposables.create() }

observable.debug("OBFS")
    .bind(to: relay)


//PlaygroundPage.current.needsIndefiniteExecution = true

//: [Next](@next)
