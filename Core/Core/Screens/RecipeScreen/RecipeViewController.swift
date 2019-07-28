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
    private let disposeBag = DisposeBag()
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
    
    public var viewModel: RecipeViewModelProtocol! = RecipeViewModel(recipe: Recipe(author: URL(string: "http://gmail.com")!,
                                                                                       source: URL(string: "http://apple.com")!,
                                                                                       original: nil,
                                                                                       images: [],
                                                                                       rawAlgorithm: """
Prepare {blender}
Add [1.25 glass of buttermilk] to the {blender}
Add [0.25 glass of powdered sugar] to the {blender}
Add [1.0 heaping teaspoon of baking powder] to the {blender}
Add [1.0 teaspoon of baking soda] to the {blender}
Add [1.0 pinch of salt] to the {blender}
Blend everything in a {blender} to a smooth mass with the consistency of thick cream
Preheat the {frying pan}
Fry pancakes on both sides in a {frying pan} over medium heat <72.0>
""",
                                                                                       time: .minutes(15),
                                                                                       people: 2,
                                                                                       difficulty: .easy,
                                                                                       country: nil))

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
