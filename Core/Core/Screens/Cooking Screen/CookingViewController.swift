//
//  CookingViewController.swift
//  Core
//
//  Created by Kamil Tustanowski on 30/06/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class CookingViewController: UITableViewController {
    private let disposeBag = DisposeBag()
    //TODOKT: Change to real view model
    var viewModel: CookingViewModelProtocol! = CookingViewModel(algorithm: Algorithm(ingredients: [], steps: [], dependencies: []))
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

private extension CookingViewController {
    func bindViewModel() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
        viewModel.output.steps.bind(to: tableView
            .rx
            .items(cellIdentifier: "CellID")) { row, viewModel, cell in
                cell.textLabel?.text = viewModel.output.title
            }
            .disposed(by: disposeBag)
    }
}
