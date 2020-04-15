//
//  ListTableCell.swift
//  Core
//
//  Created by Kamil Tustanowski on 02/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

public struct ListCellViewModel {
    // MARK: - Inputs
    public func set(title: String?) {
        titleRelay.accept(title)
    }

    public func set(description: String?) {
        descriptionRelay.accept(description)
    }

    // MARK: - Outputs
    public let title: Observable<String?>
    public let description: Observable<String?>
    public let shrinksOnTouch: Bool

    private let titleRelay: BehaviorRelay<String?>
    private let descriptionRelay: BehaviorRelay<String?>

    public init(title: String? = nil, description: String? = nil, shrinksOnTouch: Bool = false) {
        self.shrinksOnTouch = shrinksOnTouch
        
        titleRelay = BehaviorRelay<String?>(value: title)
        self.title = titleRelay.asObservable()
        
        descriptionRelay = BehaviorRelay<String?>(value: description)
        self.description = descriptionRelay.asObservable()
    }
}

extension ListCellViewModel: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(titleRelay.value)
        hasher.combine(descriptionRelay.value)
    }

    public static func == (lhs: ListCellViewModel, rhs: ListCellViewModel) -> Bool {
        return lhs.titleRelay.value == rhs.titleRelay.value
            && lhs.descriptionRelay.value == rhs.descriptionRelay.value
    }
}

public class ListTableCell: UITableViewCell {
    private(set) var disposeBag = DisposeBag()
    public var viewModel: ListCellViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var descriptionLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        containerView.roundCorners(radius: Constants.ui.cornerRadius)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descriptionLabel.text = nil
        disposeBag = DisposeBag()
    }
        
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        guard viewModel.shrinksOnTouch else { return }
        shrink(down: highlighted)
    }
}

private extension ListTableCell {
    func bindViewModel() {
        viewModel.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.description
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension ListTableCell: Themable {
    public func apply(theme: Theme = ThemeFactory.make()) {
        containerView.backgroundColor = theme.secondary
        titleLabel.textColor = theme.headerText
        descriptionLabel.textColor = theme.bodyText
        backgroundColor = theme.primary
        contentView.backgroundColor = theme.primary
    }
}

extension ListTableCell: XibMakeable {
    public typealias XibMakeableType = ListTableCell
}
