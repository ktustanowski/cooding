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
}

public class ButtonTableCell: UITableViewCell {
    public var disposeBag = DisposeBag()
    
    @IBOutlet private(set) weak var button: UIButton!
    public var viewModel: ButtonCellViewModel! {
        didSet {
            button.setTitle(viewModel.title, for: .normal)
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
        
        button.roundCorners(radius: 10) //TODO: Make a constant or sth
    }
}
