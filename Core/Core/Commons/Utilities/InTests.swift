//
//  InTests.swift
//  Core
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public func inTests() -> Bool {
    return ProcessInfo.processInfo.environment["TEST"] != nil
}
