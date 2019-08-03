//
//  RecipeListViewController.swift
//  Core
//
//  Created by Kamil Tustanowski on 29/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public final class RecipeListViewController: UITableViewController {
    private var theme: Theme = DefaultTheme()
    public let disposeBag = DisposeBag()
    public var viewModel: RecipeListViewModelProtocol!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension RecipeListViewController {
    func setupUI() {
        tableView.delaysContentTouches = false
        tableView.register(FullImageTableCell.nib, forCellReuseIdentifier: FullImageTableCell.nibName)
        tableView.separatorStyle = .none
    }
    
    func bindViewModel() {
        viewModel.output.recipies.bind(to: tableView
            .rx
            .items(cellIdentifier: FullImageTableCell.nibName)) { [weak self] _, viewModel, cell in
                guard let cell = cell as? FullImageTableCell,
                    let theme = self?.theme else { return }
                cell.apply(theme: theme)
                cell.viewModel = viewModel
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { [weak self] event in
                guard let indexPath = event.element else { return }
                self?.viewModel.input.itemSelected(indexPath: indexPath)
            }
            .disposed(by: disposeBag)
    }
}

extension RecipeListViewController: Themable {
    public func apply(theme: Theme) {
        self.theme = theme
        view.backgroundColor = theme.primary
        tableView.backgroundColor = theme.primary
    }
}
