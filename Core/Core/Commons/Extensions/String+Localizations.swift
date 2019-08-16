//
//  String+Localizations.swift
//  Core
//
//  Created by Kamil Tustanowski on 11/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
