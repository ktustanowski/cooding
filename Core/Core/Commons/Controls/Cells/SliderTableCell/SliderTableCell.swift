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
    public func set(title: String?) {
        titleRelay.accept(title)
    }
    
    public func sliderDidSlide(to value: Float) {
        self.value.accept(value)
    }
    
    // MARK: Outputs
    public let title: Observable<String?>
    public let minimum: Float
    public let maximum: Float
    
    /// Use sliderDidSlide(to value: Float) to change the value instead of using the relay directly
    public let value: BehaviorRelay<Float>
    private let titleRelay: BehaviorRelay<String?>
    
    public init(title: String? = nil, minimum: Float = 1, maximum: Float = 1, value: Float = 1) {
        self.minimum = minimum
        self.maximum = maximum
        self.value = BehaviorRelay<Float>(value: value)
        titleRelay = BehaviorRelay<String?>(value: title)
        self.title = titleRelay.asObservable()
    }
}

extension SliderCellViewModel: Hashable, Equatable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(titleRelay.value)
        hasher.combine(value.value)
        hasher.combine(maximum)
        hasher.combine(minimum)
    }

    public static func == (lhs: SliderCellViewModel, rhs: SliderCellViewModel) -> Bool {
        return lhs.titleRelay.value == rhs.titleRelay.value
            && lhs.value.value == rhs.value.value
            && lhs.maximum == rhs.maximum
            && lhs.minimum == rhs.minimum
    }
}

public final class SliderTableCell: UITableViewCell {
    private(set) var disposeBag = DisposeBag()
    
    public var viewModel: SliderCellViewModel! {
        didSet {
            slider.minimumValue = viewModel.minimum
            slider.maximumValue = viewModel.maximum
            slider.value = viewModel.value.value
            bindViewModel()
        }
    }
    
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        containerView.roundCorners(radius: Constants.ui.cornerRadius)
    }
    
    override public func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
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
                
        viewModel.title
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        titleLabel.rx.observe(String.self, "text")
            .map { $0 == nil || $0?.isEmpty == true }
            .bind(to: titleLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

extension SliderTableCell: Themable {
    public func apply(theme: Theme = ThemeFactory.make()) {
        backgroundColor = theme.primary
        containerView.backgroundColor = theme.secondary
        
        slider.tintColor = theme.primary
        slider.thumbTintColor = theme.action
        slider.backgroundColor = theme.secondary
        
        titleLabel.backgroundColor = theme.secondary
        titleLabel.textColor = theme.headerText
    }
}

extension SliderTableCell: XibMakeable {
    public typealias XibMakeableType = SliderTableCell
}
