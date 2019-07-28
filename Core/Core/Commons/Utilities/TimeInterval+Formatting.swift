//
//  TimeInterval+Formatting.swift
//  Core
//
//  Created by Kamil Tustanowski on 28/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public extension TimeInterval {
    var shortTime: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = self < .hours(1) ? [.minute, .second] : [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: self)
    }
    
    var endTime: String? {
        return Date(timeIntervalSinceNow: self).time
    }
}
