//
//  KeyValueStore.swift
//  Core
//
//  Created by Kamil Tustanowski on 03/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public protocol KeyValueStore {
    func set<T>(value: T?, for key: String)
    func value<T>(for key: String) -> T?
    func removeValue(for key: String)
}

extension UserDefaults: KeyValueStore {
    public func set<T>(value: T?, for key: String) {
        set(value, forKey: key)
    }

    public func value<T>(for key: String) -> T? {
        return value(forKey: key) as? T
    }
    
    public func removeValue(for key: String) {
        removeObject(forKey: key)
    }
}
