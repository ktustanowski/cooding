//
//  DownloaderMock.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
@testable import Core

class DownloaderMock<T: Codable>: DownloaderProtocol {
    var isLoading: Observable<Bool> {
        return isLoadingRelay.asObservable()
    }
    private var isLoadingRelay = PublishRelay<Bool>()
    
    private var returnData: Any?
    
    func download<T>(url: URL) -> Observable<T> where T: Decodable, T: Encodable {
        return Observable.create { [weak self] observer in
            
            if let returnData = self?.returnData as? T {
                observer.onNext(returnData)
            } else {
                observer.onError(DownloadError.noData)
            }
            observer.onCompleted()
            
            return Disposables.create { }
        }
    }
}

extension DownloaderMock {
    func simulateLoading(_ isLoading: Bool) {
        isLoadingRelay.accept(isLoading)
    }
    
    func simulateSuccess<T>(with data: T) {
        returnData = data
    }
}
