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
    func dismiss()
    func completedStep()
}

public protocol CookingViewModelProtocolOutputs {
    var steps: Observable<[StepCellViewModelProtocol]> { get }
    var didDismiss: Observable<Void> { get }
    var didFinish: Observable<Void> { get }
}

public final class CookingViewModel: CookingViewModelProtocol {
    public var input: CookingViewModelProtocolInputs { return self }
    public var output: CookingViewModelProtocolOutputs { return self }
    
    // MARK: Inputs
    public func dismiss() {
        didDismissRelay.accept(())
    }

    public func completedStep() {
        guard stepsRelay.value.filter({ $0.output.isDone.value == false }).isEmpty else { return }
        didFinishRelay.accept(())
    }

    // MARK: Outputs
    private let stepsRelay = BehaviorRelay<[StepCellViewModelProtocol]>(value: [])
    public var steps: Observable<[StepCellViewModelProtocol]> { return stepsRelay.asObservable() }

    public var didDismiss: Observable<Void> {
        return didDismissRelay.asObservable()
    }

    public var didFinish: Observable<Void> {
        return didFinishRelay.asObservable()
    }
    
    private let didDismissRelay = PublishRelay<Void>()
    private let didFinishRelay = PublishRelay<Void>()

    public init(algorithm: Algorithm) {
        stepsRelay.accept(algorithm.steps.map { StepCellViewModel(step: $0) })
    }
}
