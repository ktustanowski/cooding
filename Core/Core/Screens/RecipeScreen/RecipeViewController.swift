//
//  RecipeViewController.swift
//  Core
//
//  Created by Kamil Tustanowski on 28/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

public final class RecipeViewController: UITableViewController {
    public let disposeBag = DisposeBag()
    
    public var viewModel: RecipeViewModelProtocol!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }    
}

private extension RecipeViewController {
    func setupUI() {
        tableView.register(ListTableCell.nib, forCellReuseIdentifier: ListTableCell.nibName)
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        tableView.backgroundColor = .orange //TODO: Make some theme or sth - colors shared across the app
    }

    func bindViewModel() {
        let xxx = ButtonView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 100))
        xxx.roundCorners(radius: 10)
        xxx.backgroundColor = .green
        xxx.button.setTitle("Start Cooking",
                                    for: .normal)

        tableView.tableFooterView = xxx
        
        viewModel.output.items.bind(to: tableView
            .rx
            .items(cellIdentifier: ListTableCell.nibName)) { [weak self] _, viewModel, cell in
                guard let cell = cell as? ListTableCell else { return }
                cell.viewModel = viewModel
                cell.contentView.backgroundColor = self?.tableView.backgroundColor
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { event in
                guard let indexPath = event.element else { return }
                print(indexPath)
            }
            .disposed(by: disposeBag)
    }
}
