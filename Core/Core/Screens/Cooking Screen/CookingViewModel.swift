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

public protocol CookingViewModelProtocol {
    var input: CookingViewModelProtocolInputs { get }
    var output: CookingViewModelProtocolOutputs { get }
}

public protocol CookingViewModelProtocolInputs {
    
}

public protocol CookingViewModelProtocolOutputs {
    var steps: BehaviorRelay<[StepCellViewModelProtocol]> { get }
}

class CookingViewModel: CookingViewModelProtocol, CookingViewModelProtocolInputs, CookingViewModelProtocolOutputs {
    var input: CookingViewModelProtocolInputs { return self }
    var output: CookingViewModelProtocolOutputs { return self }
    
    // MARK: Outputs
    var steps = BehaviorRelay<[StepCellViewModelProtocol]>(value: [])
    
    init(algorithm: Algorithm) {
        steps.accept(algorithm.steps.map { StepCellViewModel(step: $0) })
    }
}
