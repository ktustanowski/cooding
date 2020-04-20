//
//  RecipeDescriptionCell.swift
//  Core
//
//  Created by Semerkchet on 18/04/2020.
//  Copyright © 2020 Kamil Tustanowski. All rights reserved.
//

import SwiftUI
import RxSwift
import RxRelay

public final class RecipeDescriptionViewModel {
    // MARK: - Outputs
    var title: String?
    var portions: String?
    public var didAddPortion: Observable<Void>?
    public var didRemovePortion: Observable<Void>?
    
    public init(title: String?, portions: String?) {
        self.title = title
        self.portions = portions
    }
}

public final class RecipeDescriptionCell: UITableViewCell {
    var disposeBag = DisposeBag()
    public var viewModel: RecipeDescriptionViewModel! {
        didSet {
            titleLabel.text = viewModel.title
            portionsLabel.text = viewModel.portions
            viewModel.didAddPortion = plusButton.rx.tap.asObservable()
            viewModel.didRemovePortion = minusButton.rx.tap.asObservable()
        }
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var portionsLabel: UILabel!
    @IBOutlet private(set) weak var plusButton: UIButton!
    @IBOutlet private(set) weak var minusButton: UIButton!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        containerView.roundCorners(radius: Constants.ui.cornerRadius)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        portionsLabel.text = nil
        disposeBag = DisposeBag()
    }
}

extension RecipeDescriptionCell: XibMakeable {
    public typealias XibMakeableType = RecipeDescriptionCell
}

extension RecipeDescriptionCell: Themable {
    public func apply(theme: Theme = ThemeFactory.make()) {
        containerView.backgroundColor = theme.secondary
        titleLabel.textColor = theme.headerText
        portionsLabel.textColor = theme.bodyText
        plusButton.tintColor = theme.action
        minusButton.tintColor = theme.action
        backgroundColor = theme.primary
        contentView.backgroundColor = theme.primary
    }
}
