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
        return NoDataViewModel(title: "Uh oh!", //TODO: Translations
            message: "I couldn't load recipe. Sorry about that...", //TODO: Translations
            isRetryAvailable: true)
    }
    
    static var cantLoadRecipes: NoDataViewModel {
        return NoDataViewModel(title: "Uh oh!", //TODO: Translations
            message: "I couldn't load recipies. Sorry about that...", //TODO: Translations
            isRetryAvailable: true)
    }
}
