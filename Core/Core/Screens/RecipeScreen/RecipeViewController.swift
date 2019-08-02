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

    //swiftlint:disable:next line_length
    private lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<String, RecipeCellType>> = RxTableViewSectionedReloadDataSource(configureCell: { [weak self] _, tableView, indexPath, cellType in
        
        switch cellType {
        case .listCell(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableCell.nibName, for: indexPath) as? ListTableCell
                else { fatalError("No suitable cell found!") }
            cell.viewModel = viewModel
            cell.contentView.backgroundColor = tableView.backgroundColor
            return cell
            
        case .buttonCell(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableCell.nibName, for: indexPath) as? ButtonTableCell
                else { fatalError("No suitable cell found!") }
            cell.viewModel = viewModel
            
            cell.button.rx.controlEvent(.touchUpInside).subscribe { [weak self] _ in
                self?.viewModel.input.startCookingTapped()
                }.disposed(by: cell.disposeBag)
            
            cell.contentView.backgroundColor = tableView.backgroundColor
            return cell
        }})
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
}

private extension RecipeViewController {
    func setupUI() {
        tableView.register(ListTableCell.nib, forCellReuseIdentifier: ListTableCell.nibName)
        tableView.register(ButtonTableCell.nib, forCellReuseIdentifier: ButtonTableCell.nibName)
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        tableView.backgroundColor = .orange //TODO: Make some theme or sth - colors shared across the app
    }

    func bindViewModel() {
        viewModel.output.items.bind(to: tableView
            .rx
            .items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { event in
                guard let indexPath = event.element else { return }
                print(indexPath)
            }
            .disposed(by: disposeBag)
    }
}
