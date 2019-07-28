//
//  String+Trimm.swift
//  Core
//
//  Created by Kamil Tustanowski on 29/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

public extension String {
    func trimm(_ strings: [String]) -> String {
        var output = self
        
        for string in strings {
            output = output.replacingOccurrences(of: string, with: "")
        }
        
        return output
    }
}
