//
//  Idle.swift
//  Core
//
//  Created by Kamil Tustanowski on 03/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public protocol IdleConfigurable {
    func disable()
    func enable()
}

public struct Idle: IdleConfigurable {
    public func enable() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    public func disable() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    public init() {}
}
