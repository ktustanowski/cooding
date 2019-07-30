//
//  Downloader.swift
//  Core
//
//  Created by Kamil Tustanowski on 29/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

public protocol DownloaderProtocol {
    var isLoading: PublishRelay<Bool> { get }
    func download<T: Codable>(url: URL) -> Observable<T>
}

public enum DownloadError: Error {
    case noData
    case parsingError(Error)
    case corruptedData
}

public class Downloader: DownloaderProtocol {
    /// Emmits true when starts to load and false when loading did end
    public var isLoading = PublishRelay<Bool>()
    
    public func download<T: Codable>(url: URL) -> Observable<T> {
        return Observable<T>.create({ [weak self] observer in
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            config.urlCache = nil //TODO: Check whether URL cache doesn't break github integration and waiting times
            let dataTask = URLSession(configuration: config).dataTask(with: url) { data, _, error in
                self?.isLoading.accept(false)
                guard let data = data else {
                    observer.onError(DownloadError.noData)
                    return
                }
                
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(model)
                } catch let error {
                    observer.onError(DownloadError.parsingError(error))
                }
                observer.onCompleted()
            }
            
            dataTask.resume()
            self?.isLoading.accept(true)

            return Disposables.create {
                self?.isLoading.accept(false)
                dataTask.cancel()
            }
        })
    }
    
    public init() {}
}
