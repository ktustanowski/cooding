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
    private var theme: Theme = DefaultTheme()
    public let disposeBag = DisposeBag()
    public var viewModel: CookingViewModelProtocol!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    deinit {
        print("Deinited Cooking Screen")
    }
}

private extension CookingViewController {
    func setupUI() {
        title = "Cooking steps" //TODO: Translation
        tableView.register(StepTableCell.nib, forCellReuseIdentifier: StepTableCell.nibName)
        tableView.separatorStyle = .none
        setupNavigationBar()
    }

    func setupNavigationBar() {
        replaceBackButtonWithBackArrow(theme: theme)
        
        onDismiss?
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.input.dismiss()
            })
            .disposed(by: disposeBag)
    }

    func bindViewModel() {
        viewModel.output.steps.bind(to: tableView
            .rx
            .items(cellIdentifier: StepTableCell.nibName)) { [weak self] _, viewModel, cell in
                guard let stepCell = cell as? StepTableCell,
                    let theme = self?.theme else { return }
                
                stepCell.apply(theme: theme)
                stepCell.viewModel = viewModel

                viewModel.output.didTapDone
                    .subscribe(onNext: { [weak self] _ in
                        self?.viewModel.input.completedStep()
                    })
                    .disposed(by: stepCell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

extension CookingViewController: Themable {
    public func apply(theme: Theme) {
        self.theme = theme
        view.backgroundColor = theme.primary
        tableView.backgroundColor = theme.primary
    }
}
