//
//  StepTableCell.swift
//  Core
//
//  Created by Kamil Tustanowski on 25/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

public protocol StepCellViewModelProtocol {
    var input: StepCellViewModelProtocolInputs { get }
    var output: StepCellViewModelProtocolOutputs { get }
}

public protocol StepCellViewModelProtocolInputs {
    func timerButtonTapped()
    func doneButtonTapped()
}

public protocol StepCellViewModelProtocolOutputs {
    var title: Observable<String> { get }
    var duration: Observable<String> { get }
    var endTime: Observable<String> { get }
    var isDurationAvailable: Observable<Bool> { get }
    var didTapDone: Observable<Void> { get }
    var isDone: Observable<Bool> { get }
    var isCountdown: Observable<Bool> { get }
}

public class StepTableCell: UITableViewCell {
    private(set) var disposeBag = DisposeBag()
    public var viewModel: StepCellViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var progressView: UIView!
    
    public override func awakeFromNib() {
        selectionStyle = .none
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

private extension StepTableCell {
    func bindViewModel() {
        let areControlsHidden = viewModel.output.isDurationAvailable.map { !$0 }
        
        disposeBag.insert(
            areControlsHidden
                .bind(to: counterLabel.rx.isHidden),
            areControlsHidden
                .bind(to: endLabel.rx.isHidden),
            areControlsHidden
                .bind(to: timerButton.rx.isHidden),
            areControlsHidden
                .bind(to: progressView.rx.isHidden),
            viewModel.output.isDone
                .bind(to: doneButton.rx.isHidden)
        )
        
        disposeBag.insert (
            viewModel.output.title.bind(to: descriptionLabel.rx.text),
            viewModel.output.duration
                .bind(to: counterLabel.rx.text),
            viewModel.output.endTime
                .bind(to: endLabel.rx.text)
        )
        
        disposeBag.insert (
            viewModel.output.isCountdown
                .map { $0 ? "Pause" : "Start" } //TODO: Translations
                .bind(to: timerButton.rx.title(for: .normal)),
            timerButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
                self?.viewModel.input.timerButtonTapped()
            }),
            doneButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
                self?.viewModel.input.doneButtonTapped()
            })
        )
    }
}

extension StepTableCell: XibMakeable {
    public typealias XibMakeableType = StepTableCell
}
