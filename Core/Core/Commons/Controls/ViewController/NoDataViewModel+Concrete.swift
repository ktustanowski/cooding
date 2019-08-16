//
//  NoDataViewModel+Concrete.swift
//  Core
//
//  Created by Kamil Tustanowski on 04/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

extension NoDataViewModel {
    static var cantLoadRecipe: NoDataViewModel {        
        return NoDataViewModel(title: "error.title".localized,
            message: "error.screen.didnt.load.recipe".localized,
            isRetryAvailable: true)
    }
    
    static var cantLoadRecipes: NoDataViewModel {
        return NoDataViewModel(title: "error.title".localized,
            message: "error.screen.didnt.load.recipies".localized,
            isRetryAvailable: true)
    }
}
