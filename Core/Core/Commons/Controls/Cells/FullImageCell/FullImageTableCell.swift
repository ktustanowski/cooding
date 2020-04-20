//
//  FullImageCell.swift
//  Core
//
//  Created by Kamil Tustanowski on 31/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit
import Kingfisher

public struct FullImageCellViewModel {
    public let title: String?
    public let imageURL: URL?
    public let shrinksOnTouch: Bool
    
    public init(title: String?,
                imageURL: URL?,
                shrinksOnTouch: Bool = false) {
        self.title = title
        self.imageURL = imageURL
        self.shrinksOnTouch = shrinksOnTouch
    }
}

extension FullImageCellViewModel: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(imageURL)
        hasher.combine(shrinksOnTouch)
    }
}

public class FullImageTableCell: UITableViewCell {
    public var viewModel: FullImageCellViewModel? {
        didSet {
            titleLabel.text = viewModel?.title
            titleContainer.isHidden = viewModel?.title == nil
            
            guard !inTests() else { return }
            fullImageView.kf.setImage(with: viewModel?.imageURL,
                                      options: [.scaleFactor(UIScreen.main.scale),
                                                .transition(.fade(1))])
        }
    }
    
    @IBOutlet private(set) weak var fullImageView: UIImageView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var titleContainer: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        containerView.roundCorners(radius: Constants.ui.cornerRadius)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        fullImageView.image = nil
        titleContainer.isHidden = false
        fullImageView.kf.cancelDownloadTask()
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        guard viewModel?.shrinksOnTouch == true else { return }
        shrink(down: highlighted)
    }
}

extension FullImageTableCell: Themable {
    public func apply(theme: Theme = ThemeFactory.make()) {
        containerView.backgroundColor = theme.primary
        titleContainer.backgroundColor = theme.secondary
        titleLabel.textColor = theme.headerText
        backgroundColor = theme.primary
        contentView.backgroundColor = theme.primary
    }
}

extension FullImageTableCell: XibMakeable {
    public typealias XibMakeableType = FullImageTableCell
}
