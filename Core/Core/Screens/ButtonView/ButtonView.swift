//
//  ButtonView.swift
//  Core
//
//  Created by Kamil Tustanowski on 02/08/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation

class ButtonView: UIView {
    private(set) var button = UIButton(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}

private extension ButtonView {
    func setupUI() {
        button.fillInSuperview(margins: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
    }
}
