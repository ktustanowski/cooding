//
//  ProrgessView.swift
//  Core
//
//  Created by Kamil Tustanowski on 27/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit

public class ProgressView: UIView {
    private(set) var progressIndicatorView: UIView
    
    public override init(frame: CGRect) {
        progressIndicatorView = UIView(frame: .zero)
        super.init(frame: frame)
        
        setupIndicatorView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        progressIndicatorView = UIView(frame: .zero)
        progressIndicatorView.backgroundColor = .red
        super.init(coder: aDecoder)
        
        setupIndicatorView()
    }
    
    public func show(progress: Int, animated: Bool) {
        
    }
}

private extension ProgressView {
    func setupIndicatorView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(progressIndicatorView)
        NSLayoutConstraint.activate([
            progressIndicatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            progressIndicatorView.topAnchor.constraint(equalTo: self.topAnchor),
            progressIndicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            progressIndicatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
}
