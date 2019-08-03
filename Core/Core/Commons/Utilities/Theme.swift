//
//  Theme.swift
//  Core
//
//  Created by Kamil Tustanowski on 03/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public protocol Themable {
    func apply(theme: Theme)
}

public protocol Theme {
    var primary: UIColor { get }
    var secondary: UIColor { get }
    var auxiliary: UIColor { get }
    var action: UIColor { get }
    var positive: UIColor { get }
    var headerText: UIColor { get }
    var bodyText: UIColor { get }
}

public struct DefaultTheme: Theme {
    public let primary = UIColor(hex: "#FA9B28FF")!
    public let secondary: UIColor = .white
    public let auxiliary: UIColor = UIColor(hex: "#FABC3CFF")!
    public let positive: UIColor = UIColor(hex: "#2ECC40FF")!
    public let action = UIColor(hex: "#F55536FF")!
    public let headerText = UIColor(hex: "#FA9B28FF")!
    public let bodyText = UIColor(hex: "#6C6C6CFF")!
    
    public init() {}
}
