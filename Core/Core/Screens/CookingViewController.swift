//
//  CookingViewController.swift
//  Core
//
//  Created by Kamil Tustanowski on 30/06/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit
import RxSwift

public protocol CookingViewModelProtocol {
    var input: CookingViewModelProtocolInputs { get }
    var output: CookingViewModelProtocolOutputs { get }
}

public protocol CookingViewModelProtocolInputs {
    
}

public protocol CookingViewModelProtocolOutputs {
    
}

public class CookingViewController: UITableViewController {
    
}
