//
//  TimeInterval+Creation.swift
//  Core
//
//  Created by Kamil Tustanowski on 28/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public extension TimeInterval {
    static func minutes(_ minutes: TimeInterval) -> TimeInterval {
        return 60.0 * minutes
    }
    
    static func hours(_ hours: TimeInterval) -> TimeInterval {
        return .minutes(60) * hours
    }
}
