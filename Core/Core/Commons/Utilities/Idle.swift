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
    /// App will go background as usual
    public func enable() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    /// Stop application from going background
    public func disable() {
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    public init() {}
}
