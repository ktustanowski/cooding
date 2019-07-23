import UIKit
import PlaygroundSupport
import Core
import RxSwift
import RxRelay



//let bag = DisposeBag()
//
//enum FetchWeatherError: Error {
//    case unknown
//    case undecodable
//}
//let getWeather = Observable<String>.create { observer in
//    let url = URL(string: "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22")!
//    let session = URLSession.shared
//    let task = session.dataTask(with: url) { data, response, error in
//        guard let data = data else {
//            observer.onError(FetchWeatherError.unknown)
//            return
//        }
//
//        guard let decodedString = String(data: data, encoding: .utf8) else {
//            observer.onError(FetchWeatherError.undecodable)
//            return
//        }
//
//        observer.onNext(decodedString)
//    }
//
//    task.resume()
//    return Disposables.create()
//}
//
//getWeather.subscribe(onNext: { print($0) },
//                     onError: { print($0) })
//    .disposed(by: bag)

//let variable = BehaviorRelay<String>(value: "1st value")
//variable.accept("2nd value")
//
//print(variable.value)

//variable.asObservable()
//    .subscribe(accept { print($0) })
//    .disposed(by: bag)

//let behaviorSubject = BehaviorSubject<String>(value: "1st value")
//behaviorSubject
//    .subscribe(onNext: { print($0) })
//    .disposed(by: bag)
//behaviorSubject.onNext("2nd value")
//
//let subject = PublishSubject<String>()
//subject.onNext("Test")
//subject.subscribe(onNext:{ print($0) }).disposed(by: bag)

var cookingViewController = CookingViewController()
var navigationController = UINavigationController(rootViewController: cookingViewController)

PlaygroundPage.current.liveView = navigationController.view
PlaygroundPage.current.needsIndefiniteExecution = true
