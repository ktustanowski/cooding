//
//  EphemeralKeyValueStore.swift
//  CoodingTests
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
@testable import Core

final class EphemeralKeyValueStore: KeyValueStore {
    private var storage = [String: Any]()
    
    func set<T>(value: T?, for key: String) {
        storage[key] = value
    }
    
    func value<T>(for key: String) -> T? {
        return storage[key] as? T
    }
    
    func removeValue(for key: String) {
        storage.removeValue(forKey: key)
    }
}
