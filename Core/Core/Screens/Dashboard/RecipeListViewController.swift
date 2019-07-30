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
    private let disposeBag = DisposeBag()
    public var viewModel: RecipeListViewModelProtocol!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(BasicTableCell.self, forCellReuseIdentifier: BasicTableCell.nibName)
        bindViewModel()
    }
}

extension RecipeListViewController {
    func bindViewModel() {
        viewModel.output.recipies.bind(to: tableView
            .rx
            .items(cellIdentifier: BasicTableCell.nibName)) { _, viewModel, cell in
                guard let cell = cell as? BasicTableCell else { return }
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
