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
    public let title: String
    public let description: String
    public let shrinksOnTouch: Bool
    
    public init(title: String, description: String, shrinksOnTouch: Bool = false) {
        self.title = title
        self.description = description
        self.shrinksOnTouch = shrinksOnTouch
    }
}

extension ListCellViewModel: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(description)
    }

    public static func == (lhs: ListCellViewModel, rhs: ListCellViewModel) -> Bool {
        return lhs.title == rhs.title
            && lhs.description == rhs.description
    }
}

public class ListTableCell: UITableViewCell {
    private(set) var disposeBag = DisposeBag()

    public var viewModel: ListCellViewModel! {
        didSet {
            titleLabel.text = viewModel.title
            descriptionLabel.text = viewModel.description
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
