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
    
}

public protocol CookingViewModelProtocolOutputs {
    var steps: Observable<[StepCellViewModelProtocol]> { get }
}

class CookingViewModel: CookingViewModelProtocol {
    var input: CookingViewModelProtocolInputs { return self }
    var output: CookingViewModelProtocolOutputs { return self }
    
    // MARK: Outputs
    private let stepsRelay = BehaviorRelay<[StepCellViewModelProtocol]>(value: [])
    var steps: Observable<[StepCellViewModelProtocol]> { return stepsRelay.asObservable() }
    
    init(algorithm: Algorithm) {        
        stepsRelay.accept(algorithm.steps.map { StepCellViewModel(step: $0) })
    }
}
