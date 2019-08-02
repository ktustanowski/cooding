//
//  FullImageCell.swift
//  Core
//
//  Created by Kamil Tustanowski on 31/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit

public struct FullImageCellViewModel {
    public let title: String
    public let imageURL: URL?
    
    public init(title: String, imageURL: URL?) {
        self.title = title
        self.imageURL = imageURL
    }
}

public class FullImageTableCell: UITableViewCell {
    public var viewModel: FullImageCellViewModel! {
        didSet {
            titleLabel.text = viewModel.title
            // TODO: Add image loading here
        }
    }
    
    @IBOutlet private(set) weak var fullImageView: UIImageView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        containerView.roundCorners(radius: 10) //TODO: Make a constant or sth
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        fullImageView.image = nil
    }
    
    //TODO: refactor and make configurable
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        shrink(down: highlighted)
    }
    
    func shrink(down: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.allowUserInteraction], animations: {
            if down {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            } else {
                self.transform = .identity
            }
        }, completion: nil)
    }
}

extension FullImageTableCell: XibMakeable {
    public typealias XibMakeableType = FullImageTableCell
}
