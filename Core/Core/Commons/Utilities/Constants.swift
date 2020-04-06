//
//  Constants.swift
//  Core
//
//  Created by Kamil Tustanowski on 03/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

struct Constants {
    //swiftlint:disable:next identifier_name
    static let ui = UIConstants.self
    static let general = GeneralConstants.self
}

struct UIConstants {
    static let cornerRadius: CGFloat = 10.0
}

struct GeneralConstants {
    static let maxPortions = 10
}
