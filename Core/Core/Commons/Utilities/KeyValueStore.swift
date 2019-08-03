//
//  KeyValueStore.swift
//  Core
//
//  Created by Kamil Tustanowski on 03/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public protocol KeyValueStore: AnyObject {
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

// MARK: Recipe List URL

public extension KeyValueStore {
    var recipeListURL: URL? {
        get {
            guard let urlString: String = value(for: "recipe_list_url_key") else { return nil }
            return URL(string: urlString)
        }
        
        set {
            set(value: newValue?.absoluteString, for: "recipe_list_url_key")
        }
    }
}
