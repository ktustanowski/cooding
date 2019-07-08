//
//  CookingViewController.swift
//  Core
//
//  Created by Kamil Tustanowski on 30/06/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

public protocol CookingViewModelProtocol {
    var input: CookingViewModelProtocolInputs { get }
    var output: CookingViewModelProtocolOutputs { get }
}

public protocol CookingViewModelProtocolInputs {
    
}

public protocol CookingViewModelProtocolOutputs {
    var steps: BehaviorRelay<[String]> { get }
}

class CookingViewModel: CookingViewModelProtocol, CookingViewModelProtocolInputs, CookingViewModelProtocolOutputs {
    var input: CookingViewModelProtocolInputs { return self }
    var output: CookingViewModelProtocolOutputs { return self }
    
    var steps = BehaviorRelay<[String]>(value: [])
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.steps.accept(["Buy stuff 🤑", "Cook 🤩", "Eat 🤪"])
        }
    }
}

public class CookingViewController: UITableViewController {
    private let disposeBag = DisposeBag()
    var viewModel: CookingViewModelProtocol = CookingViewModel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.output.steps
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        viewModel.output.steps.bind(to: tableView.rx.items(cellIdentifier: "CellID")) { row, model, cell in
                cell.textLabel?.text = model
            }
            .disposed(by: disposeBag)
    }
}
