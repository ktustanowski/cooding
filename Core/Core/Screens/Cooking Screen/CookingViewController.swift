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
                guard let stepCell = cell as? StepTableCell else { return }
                stepCell.viewModel = viewModel

                viewModel.output.didTapDone
                    .subscribe(onNext: { _ in
                        guard let indexPathToRemove = self?.tableView.indexPath(for: stepCell) else { return }
                        self?.viewModel.input.finished(at: indexPathToRemove)
                        
                    }).disposed(by: stepCell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}
