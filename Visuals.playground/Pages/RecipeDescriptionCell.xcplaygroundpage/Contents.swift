//: [Previous](@previous)

import Foundation
import Core
import RxSwift
import PlaygroundSupport

let disposeBag = DisposeBag()

func makeCell(theme: Theme) -> RecipeDescriptionCell {
    let cell = RecipeDescriptionCell.make()
    cell.viewModel = RecipeDescriptionViewModel(title: "Description", portions: "Portions - 5")

    cell.apply(theme: theme)
    cell.backgroundColor = theme.primary
    
    cell.viewModel.didAddPortion?
        .subscribe(onNext: { print("+") })
        .disposed(by: disposeBag)
    
    cell.viewModel.didRemovePortion?
        .subscribe(onNext: { print("-") })
        .disposed(by: disposeBag)
    
    return cell
}

let lightCell = makeCell(theme: LightTheme())
let darkCell = makeCell(theme: DarkTheme())

let view = UIStackView(arrangedSubviews: [lightCell.contentView,
                                          darkCell.contentView])
view.distribution = .fillEqually
view.axis = .vertical
view.frame = lightCell.frame
view.frame.size.height = 2 * view.frame.height

PlaygroundPage.current.liveView = view

//: [Next](@next)
