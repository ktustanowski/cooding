//
//  Theme.swift
//  Core
//
//  Created by Kamil Tustanowski on 03/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

protocol Themable: AnyObject {
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

public struct LightTheme: Theme {
    public let primary = UIColor(hex: "#FA9B28FF")!
    public let secondary: UIColor = .white
    public let auxiliary: UIColor = UIColor(hex: "#FABC3CFF")!
    
    public let positive: UIColor = UIColor(hex: "#2ECC40FF")!
    public let action = UIColor(hex: "#F55536FF")!
    public let headerText = UIColor(hex: "#FA9B28FF")!
    public let bodyText = UIColor(hex: "#6C6C6CFF")!
    
    public init() {}
}

public struct DarkTheme: Theme {
    public let primary: UIColor = UIColor(hex: "#222831FF")!
    public let secondary: UIColor = UIColor(hex: "#2D4059FF")!
    public let auxiliary: UIColor = UIColor(hex: "#2D4059FF")!
    
    public let positive: UIColor = UIColor(hex: "#2ECC40FF")!
    public let action = UIColor(hex: "#FD7014FF")!
    public let headerText = UIColor(hex: "#F5EDEDFF")!
    public let bodyText = UIColor(hex: "#F5EDEDFF")!

    public init() {}
}

public struct ThemeFactory {
    public static func make() -> Theme {
        if #available(iOS 12.0, *) {
            if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                return DarkTheme()
            } else {
                return LightTheme()
            }
        } else {
            return LightTheme()
        }
    }
}
