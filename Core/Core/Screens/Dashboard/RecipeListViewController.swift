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
        tableView.backgroundColor = UIColor(hex: "#F19143FF")//UIColor(hex: "#B4DFE5FF")//UIColor(hex: "#FF773DFF")
        print(UIColor(hex: "#F4976CFF"))
    }
    
    func bindViewModel() {
        viewModel.output.recipies.bind(to: tableView
            .rx
            .items(cellIdentifier: FullImageTableCell.nibName)) { [weak self] _, viewModel, cell in
                guard let cell = cell as? FullImageTableCell else { return }
                cell.viewModel = viewModel
                cell.titleLabel.textColor = UIColor(hex: "#F55536FF")//UIColor(hex: "#B4DFE5FF")
                cell.contentView.backgroundColor = self?.tableView.backgroundColor
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
