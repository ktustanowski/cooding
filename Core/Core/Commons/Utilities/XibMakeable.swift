//
//  XibMakeable.swift
//  Core
//
//  Created by Kamil Tustanowski on 25/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public protocol XibMakeable: class {
    associatedtype XibMakeableType
    static func make() -> XibMakeableType
}

public extension XibMakeable where Self: UIView {
    static func make() -> XibMakeableType {
        let viewId = NSStringFromClass(self).components(separatedBy: ".").last ?? ""
        guard let view = Bundle(for: self).loadNibNamed(viewId,
                                                        owner: nil,
                                                        options: nil)?.last as? XibMakeableType
            else { fatalError("Couldn't make view from \(viewId).xib!") }
        
        return view
    }
}
