//
//  ListTableCell.swift
//  Core
//
//  Created by Kamil Tustanowski on 02/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit

public struct ListCellViewModel {
    public let title: String
    public let description: String
    
    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

public class ListTableCell: UITableViewCell {
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
        containerView.roundCorners(radius: 10) //TODO: Make a constant or sth
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
        
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        shrink(down: highlighted)
    }
}

extension ListTableCell: XibMakeable {
    public typealias XibMakeableType = ListTableCell
}
