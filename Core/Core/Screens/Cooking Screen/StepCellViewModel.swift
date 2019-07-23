//
//  StepCellViewModel.swift
//  Core
//
//  Created by Kamil Tustanowski on 23/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public protocol StepCellViewModelProtocol {
    var input: StepCellViewModelProtocolInputs { get }
    var output: StepCellViewModelProtocolOutputs { get }
}

public protocol StepCellViewModelProtocolInputs {
    
}

public protocol StepCellViewModelProtocolOutputs {
    var title: String { get }
}

class StepCellViewModel: StepCellViewModelProtocol, StepCellViewModelProtocolInputs, StepCellViewModelProtocolOutputs {
    private let step: Step
    var input: StepCellViewModelProtocolInputs { return self }
    var output: StepCellViewModelProtocolOutputs { return self }
    
    // MARK: - Outputs
    var title: String { return step.description}
    
    init(step: Step) {
        self.step = step
    }
}
