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
        
        button.roundCorners(radius: 10) //TODO: Make a constant or sth
    }
}
