//
//  SliderTableCell.swift
//  Core
//
//  Created by Kamil Tustanowski on 08/11/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

public struct SliderCellViewModel {
    // MARK: Inputs
    public func sliderDidSlide(to value: Float) {
        valueRelay.accept(value)
    }
    
    // MARK: Outputs
    public let minimum: Float
    public let maximum: Float
    public var value: Observable<Float>
    private var valueRelay = BehaviorRelay<Float>(value: 0)
    
    public init(minimum: Float = 1, maximum: Float = 1) {
        self.minimum = minimum
        self.maximum = maximum
        value = valueRelay.asObservable()
    }
}

public final class SliderTableCell: UITableViewCell {
    public var disposeBag = DisposeBag()
    public var viewModel: SliderCellViewModel! {
        didSet {
            slider.minimumValue = viewModel.minimum
            slider.maximumValue = viewModel.maximum            
            bindViewModel()
        }
    }
    @IBOutlet private weak var slider: UISlider!
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

private extension SliderTableCell {
    func bindViewModel() {
        slider.rx
            .value
            .map { floor($0) }
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] value in
                self.viewModel.sliderDidSlide(to: value)
            })
            .disposed(by: disposeBag)
    }
}

extension SliderTableCell: Themable {
    public func apply(theme: Theme) {
        slider.tintColor = theme.primary
        slider.thumbTintColor = theme.action
        slider.backgroundColor = theme.secondary
    }
}

extension SliderTableCell: XibMakeable {
    public typealias XibMakeableType = SliderTableCell
}
