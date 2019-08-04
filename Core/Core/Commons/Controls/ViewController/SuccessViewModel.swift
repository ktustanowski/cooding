//
//  SuccessViewModel.swift
//  Core
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

public protocol SuccessViewModelProtocol: SuccessViewModelProtocolInputs, SuccessViewModelProtocolOutputs {
    var input: SuccessViewModelProtocolInputs { get }
    var output: SuccessViewModelProtocolOutputs { get }
}

public protocol SuccessViewModelProtocolInputs {}

public protocol SuccessViewModelProtocolOutputs {
    var title: String { get }
    var imageName: String { get }
    var didDismiss: Observable<Void> { get }
}

public final class SuccessViewModel: SuccessViewModelProtocol {
    private let dismissTimer: Timer?
    public var input: SuccessViewModelProtocolInputs { return self }
    public var output: SuccessViewModelProtocolOutputs { return self }
    
    // MARK: Outputs
    public var title: String
    public var imageName: String
    public var didDismiss: Observable<Void> {
        return didDismissRelay.asObservable()
    }
    public var didDismissRelay = PublishRelay<Void>()
    
    public init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
        let dismissRelay = PublishRelay<Void>()
        didDismissRelay = dismissRelay
        
        dismissTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
            dismissRelay.accept(())
        })
    }
    
    deinit {
        dismissTimer?.invalidate()
    }
}
