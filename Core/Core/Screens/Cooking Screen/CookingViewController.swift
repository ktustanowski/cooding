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

public final class CookingViewController: UITableViewController {
    private let disposeBag = DisposeBag()
    public var viewModel: CookingViewModelProtocol!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

private extension CookingViewController {
    func bindViewModel() {
        tableView.register(StepTableCell.nib, forCellReuseIdentifier: StepTableCell.nibName)
        
        viewModel.output.steps.bind(to: tableView
            .rx
            .items(cellIdentifier: StepTableCell.nibName)) { [weak self] _, viewModel, cell in
                guard let stepCell = cell as? StepTableCell, let strongSelf = self else { return }
                stepCell.viewModel = viewModel
                
                viewModel.output.didTapDone
                    .subscribe(onNext: { _ in
                        // TODO: maybe refactor to use animated DS or just switch to reload a cell or sth
                        strongSelf.tableView.reloadData()
                    }).disposed(by: stepCell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
