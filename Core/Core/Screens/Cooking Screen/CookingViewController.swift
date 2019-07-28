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

public class CookingViewController: UITableViewController {
    private let disposeBag = DisposeBag()
    //TODOKT: Change to real view model
    public var viewModel: CookingViewModelProtocol! = CookingViewModel(algorithm: Algorithm(ingredients: [], steps: RecipeFactory.pancakes(), dependencies: []))
    
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
                guard let stepCell = cell as? StepTableCell, let strongSelf = self else { return }
                stepCell.viewModel = viewModel
                
                viewModel.output.didTapDone
                    .subscribe(onNext: { _ in
                        strongSelf.tableView.reloadData()
                    }).disposed(by: stepCell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
}

private extension CookingViewController {
    
}

struct RecipeFactory {
    static func pancakes() -> [Step] {
        return [Step(description: "Prepare blender",
                     dependencies: [Dependency(name: "blender")],
                     ingredients: nil, duration: 20.0),
                Step(description: "Add 1.25 glass of buttermilk to the blender",
                     dependencies: [Dependency(name: "blender")],
                     ingredients: [Ingredient(name: "glass off buttermilk", quantity: 1.25)]),
                Step(description: "Add 0.25 glass of powdered sugar to the blender",
                     dependencies: [Dependency(name: "blender")],
                     ingredients: [Ingredient(name: "glass of powdered sugar", quantity: 0.25)]),
                Step(description: "Add 1 heaping teaspoon of baking powder to the blender",
                     dependencies: [Dependency(name: "blender")],
                     ingredients: [Ingredient(name: "heaping teaspoon of baking powder", quantity: 1.0)]),
                Step(description: "Add 1 teaspoon of baking soda to the blender",
                     dependencies: [Dependency(name: "blender")],
                     ingredients: [Ingredient(name: "teaspoon of baking soda", quantity: 1.0)], duration: 100.0),
                Step(description: "Add 1 pinch of salt to the blender",
                     dependencies: [Dependency(name: "blender")],
                     ingredients: [Ingredient(name: "pinch of salt", quantity: 1.0)]),
                Step(description: "Blend everything in a blender to a smooth mass with the consistency of thick cream",
                     dependencies: [Dependency(name: "blender")]),
                Step(description: "Preheat the frying pan",
                     dependencies: [Dependency(name: "frying pan")]),
                Step(description: "Fry pancakes on both sides in a frying pan over medium heat",
                     dependencies: [Dependency(name: "frying pan")], duration: 256.0)]
    }
}
