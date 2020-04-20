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
    private var theme: Theme = ThemeFactory.make()
    public let disposeBag = DisposeBag()
    public var viewModel: RecipeViewModelProtocol!
    
    //swiftlint:disable:next line_length
    private lazy var dataSource: RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, RecipeCellType>> = RxTableViewSectionedAnimatedDataSource(configureCell: { [weak self] _, tableView, indexPath, cellType in
        guard let strongSelf = self else { fatalError("No theme available!") }
        
        switch cellType {
        case .descriptionCell(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDescriptionCell.nibName, for: indexPath) as? RecipeDescriptionCell
                else { fatalError("No suitable cell found!") }

            cell.viewModel = viewModel
            cell.apply(theme: strongSelf.theme)
            
            cell.viewModel.didAddPortion?.subscribe(onNext: { [weak self] in
                    self?.viewModel.input.addPortion()
                })
                .disposed(by: cell.disposeBag)

            cell.viewModel.didRemovePortion?.subscribe(onNext: { [weak self] in
                    self?.viewModel.input.removePortion()
                })
                .disposed(by: cell.disposeBag)

            return cell
        case .listCell(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableCell.nibName, for: indexPath) as? ListTableCell
                else { fatalError("No suitable cell found!") }

            cell.viewModel = viewModel
            cell.apply(theme: strongSelf.theme)
            
            return cell
        case .buttonCell(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableCell.nibName, for: indexPath) as? ButtonTableCell
                else { fatalError("No suitable cell found!") }

            cell.viewModel = viewModel
            cell.apply(theme: strongSelf.theme)

            cell.button.rx.controlEvent(.touchUpInside)
                .subscribe { [weak self] _ in
                    self?.viewModel.input.startCookingTapped()
                }
                .disposed(by: cell.disposeBag)

            return cell
        case .imageCell(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FullImageTableCell.nibName, for: indexPath) as? FullImageTableCell
                else { fatalError("No suitable cell found!") }

            cell.viewModel = viewModel
            cell.apply(theme: strongSelf.theme)

            return cell
        case .sliderCell(let viewModel):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SliderTableCell.nibName, for: indexPath) as? SliderTableCell
                else { fatalError("No suitable cell found!") }

            cell.viewModel = viewModel
            cell.apply(theme: strongSelf.theme)
            
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
        tableView.register(FullImageTableCell.nib, forCellReuseIdentifier: FullImageTableCell.nibName)
        tableView.register(SliderTableCell.nib, forCellReuseIdentifier: SliderTableCell.nibName)
        tableView.register(RecipeDescriptionCell.nib, forCellReuseIdentifier: RecipeDescriptionCell.nibName)
        
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = false
        
        dataSource.animationConfiguration = AnimationConfiguration(insertAnimation: .fade,
                                                                   reloadAnimation: .fade,
                                                                   deleteAnimation: .fade)
    }

    func bindViewModel() {
        viewModel.output.items.bind(to: tableView
            .rx
            .items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension RecipeViewController: Themable {
    public func apply(theme: Theme = ThemeFactory.make()) {
        self.theme = theme
        navigationController?.navigationBar.tintColor = theme.action
        view.backgroundColor = theme.primary
        tableView.backgroundColor = theme.primary
    }
}
