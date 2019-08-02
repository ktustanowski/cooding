//
//  CookingViewModel.swift
//  Core
//
//  Created by Kamil Tustanowski on 23/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

public protocol CookingViewModelProtocol: CookingViewModelProtocolInputs, CookingViewModelProtocolOutputs {
    var input: CookingViewModelProtocolInputs { get }
    var output: CookingViewModelProtocolOutputs { get }
}

public protocol CookingViewModelProtocolInputs {
    func finished(at indexPath: IndexPath)
    func dismiss()
}

public protocol CookingViewModelProtocolOutputs {
    var steps: Observable<[StepCellViewModelProtocol]> { get }
    var didDismiss: Observable<Void> { get }
}

public final class CookingViewModel: CookingViewModelProtocol {
    public var input: CookingViewModelProtocolInputs { return self }
    public var output: CookingViewModelProtocolOutputs { return self }
    
    // MARK: Inputs
    public func finished(at indexPath: IndexPath) {
        var steps = stepsRelay.value
        steps.remove(at: indexPath.row)
        stepsRelay.accept(steps)
    }
    
    public func dismiss() {
        didDismissRelay.accept(())
    }
    
    public var didDismiss: Observable<Void> {
        return didDismissRelay.asObservable()
    }

    // MARK: Outputs
    private let stepsRelay = BehaviorRelay<[StepCellViewModelProtocol]>(value: [])
    public var steps: Observable<[StepCellViewModelProtocol]> { return stepsRelay.asObservable() }
    
    private let didDismissRelay = PublishRelay<Void>()
    
    public init(algorithm: Algorithm) {
        stepsRelay.accept(algorithm.steps.map { StepCellViewModel(step: $0) })
    }
}
