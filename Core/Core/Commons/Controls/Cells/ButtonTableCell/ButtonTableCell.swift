//
//  ButtonTableCell.swift
//  Core
//
//  Created by Kamil Tustanowski on 02/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit
import RxSwift

public struct ButtonCellViewModel {
    public let title: String
    
    public init(title: String) {
        self.title = title
    }
}

public class ButtonTableCell: UITableViewCell {
    private(set) var disposeBag = DisposeBag()
    
    @IBOutlet private(set) weak var button: UIButton!
    public var viewModel: ButtonCellViewModel! {
        didSet {
            button.setTitle(viewModel.title, for: .normal)
            bindViewModel()
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        button.setTitle(nil, for: .normal)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        button.roundCorners(radius: Constants.ui.cornerRadius)
    }
}

private extension ButtonTableCell {
    func bindViewModel() {
        button.rx
            .controlEvent(.touchDown)
            .subscribe(onNext: { [weak self] in
                self?.shrink(down: true)
            })
            .disposed(by: disposeBag)
        
        button.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                self?.shrink(down: false)
            })
            .disposed(by: disposeBag)
    }
}

extension ButtonTableCell: Themable {
    public func apply(theme: Theme = ThemeFactory.make()) {
        button.backgroundColor = theme.action
        button.setTitleColor(.white, for: .normal)
        backgroundColor = theme.primary
        contentView.backgroundColor = theme.primary
    }
}

extension ButtonTableCell: XibMakeable {
    public typealias XibMakeableType = ButtonTableCell
}
