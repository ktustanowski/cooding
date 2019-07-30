//
//  StoryboardMakeable.swift
//  Core
//
//  Created by Kamil Tustanowski on 29/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit

/// The purpose of this protocol & extension is to make instantiating view controllers
/// form a storyboard super easy.
///
/// To make it work you just need to implement two vars
/// in given view controller and then wherewer you need and instance of it you just go as:
/// SomeViewController.make() and thats it. It's also typesafe.
/// - Warning:
/// Storyboard ID MUST equal view controllers name for this to work
public protocol StoryboardMakeable: class {
    associatedtype StoryboardMakeableType
    static var storyboardName: String { get }
    static func make() -> StoryboardMakeableType
}

public extension StoryboardMakeable where Self: UIViewController {
    static func make() -> StoryboardMakeableType {
        let viewControllerId = NSStringFromClass(self).components(separatedBy: ".").last ?? ""
        
        return make(with: viewControllerId)
    }
    
    static func make(with viewControllerId: String) -> StoryboardMakeableType {
        let storyboard = UIStoryboard(name: storyboardName,
                                      bundle: Bundle(for: self))
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerId) as? StoryboardMakeableType else {
            fatalError("Did not found \(viewControllerId) in \(storyboardName)!")
        }
        
        return viewController
    }
}
