//
//  Downloader.swift
//  Core
//
//  Created by Kamil Tustanowski on 29/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift

public protocol DownloaderProtocol {
    func download<T: Codable>(url: URL) -> Observable<T>
}

public enum DownloadError: Error {
    case noData
    case parsingError(Error)
    case corruptedData
}

public struct Downloader: DownloaderProtocol {
    public func download<T: Codable>(url: URL) -> Observable<T> {
        return Observable<T>.create({ observer in
            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
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
            
            return Disposables.create {
                dataTask.cancel()
            }
        })
    }
    
    public init() {}
}
