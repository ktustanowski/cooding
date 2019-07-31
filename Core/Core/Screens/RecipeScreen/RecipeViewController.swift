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
    private var dataSource = RxTableViewSectionedReloadDataSource<RecipeSectionModel>(configureCell: { _, tableView, indexPath, item in
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableCell.nibName, for: indexPath) as? BasicTableCell
            else { fatalError("No compatibile cell found!") }

        switch item {
        case .info(let viewModel):
            cell.viewModel = viewModel
        case .ingredient(let viewModel):
            cell.viewModel = viewModel
        case .dependency(let viewModel):
            cell.viewModel = viewModel
        case .step(let viewModel):
            cell.viewModel = viewModel
        }
        
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        return cell })
    
    public var viewModel: RecipeViewModelProtocol!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(BasicTableCell.self, forCellReuseIdentifier: BasicTableCell.nibName)
        bindViewModel()
    }
}

private extension RecipeViewController {
    func bindViewModel() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel.output.sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension RecipeViewController {
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch RecipeSection.AllCases()[section] {
        case .info:
            return "INFO"
        case .ingredients:
            return "INGREDIENTES"
        case .dependencies:
            return "INGREDIENTES"
        case .steps:
            return "STEPS"
        }
    }
}
