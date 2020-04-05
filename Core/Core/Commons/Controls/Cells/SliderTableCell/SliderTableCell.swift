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
        self.value.accept(value)
    }
    
    // MARK: Outputs
    public let minimum: Float
    public let maximum: Float
    /// Use sliderDidSlide(to value: Float) to change the value instead of using the relay directly
    public let value: BehaviorRelay<Float>
    
    public init(minimum: Float = 1, maximum: Float = 1, value: Float = 1) {
        self.minimum = minimum
        self.maximum = maximum
        self.value = BehaviorRelay<Float>(value: value)
    }
}

public final class SliderTableCell: UITableViewCell {
    public var disposeBag = DisposeBag()
    public var viewModel: SliderCellViewModel! {
        didSet {
            slider.minimumValue = viewModel.minimum
            slider.maximumValue = viewModel.maximum
            slider.value = viewModel.value.value
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
    public func apply(theme: Theme = ThemeFactory.make()) {
        slider.tintColor = theme.primary
        slider.thumbTintColor = theme.action
        slider.backgroundColor = theme.secondary
    }
}

extension SliderTableCell: XibMakeable {
    public typealias XibMakeableType = SliderTableCell
}
