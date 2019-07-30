//
//  NoDataViewModel.swift
//  Core
//
//  Created by Kamil Tustanowski on 30/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

public protocol NoDataViewModelProtocol: NoDataViewModelProtocolInputs, NoDataViewModelProtocolOutputs {
    var input: NoDataViewModelProtocolInputs { get }
    var output: NoDataViewModelProtocolOutputs { get }
}

public protocol NoDataViewModelProtocolInputs {
    func retryTapped()
}

public protocol NoDataViewModelProtocolOutputs {
    var title: Observable<String> { get }
    var message: Observable<String?> { get }
    var isRetryAvailable: Observable<Bool> { get }
    var didTapRetry: Observable<Void> { get }
}

public final class NoDataViewModel: NoDataViewModelProtocol {
    public var input: NoDataViewModelProtocolInputs { return self }
    public var output: NoDataViewModelProtocolOutputs { return self }
    
    // MARK: Inputs
    public func retryTapped() {
        didTapRetryRelay.accept(())
    }
    
    // MARK: Outputs
    public var title: Observable<String>
    public var message: Observable<String?>
    public var isRetryAvailable: Observable<Bool>
    public var didTapRetry: Observable<Void> {
        return didTapRetryRelay.asObservable()
    }
    
    private var didTapRetryRelay = PublishRelay<Void>()
    
    public init(title: String, message: String?, isRetryAvailable: Bool) {
        self.title = .just(title)
        self.message = .just(message)
        self.isRetryAvailable = .just(isRetryAvailable)
    }
}
