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
    
    func trimTrailingSpace() -> String {
        return self.last == .space ? String(self.dropLast()) : self
    }
    
    // TODO: Make this smarter - possibly extension to a number would be best
    func trimTrailingZeros() -> String {
        return self.replacingOccurrences(of: ".00", with: "")
            .replacingOccurrences(of: ",00", with: "")
            .replacingOccurrences(of: ",0", with: "")
            .replacingOccurrences(of: ".0", with: "")
    }
}

public extension Character {
    static let space = Character(" ")
}
