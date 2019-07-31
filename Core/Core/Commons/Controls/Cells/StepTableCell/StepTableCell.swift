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

public class StepTableCell: UITableViewCell {
    private(set) var disposeBag = DisposeBag()
    public var viewModel: StepCellViewModelProtocol! {
        didSet {
            bindViewModel()
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var durationControlsContainer: UIView!
    
    public override func awakeFromNib() {
        selectionStyle = .none
        clear()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        descriptionLabel.text = nil
        counterLabel.text = nil
        endLabel.text = nil
        timerButton.setTitle(nil, for: .normal)
        clear()
    }
}

private extension StepTableCell {
    func clear() {
        descriptionLabel.text = nil
        counterLabel.text = nil
        endLabel.text = nil
        timerButton.setTitle(nil, for: .normal)
    }
    
    func bindViewModel() {
        disposeBag.insert (
            viewModel.output.isDurationAvailable
                .map { !$0 }
                .bind(to: durationControlsContainer.rx.isHidden),
            viewModel.output.title
                .observeOn(MainScheduler.instance)
                .bind(to: descriptionLabel.rx.text),
            viewModel.output.duration
                .observeOn(MainScheduler.instance)
                .bind(to: counterLabel.rx.text),
            viewModel.output.endTime
                .observeOn(MainScheduler.instance)
                .bind(to: endLabel.rx.text)
        )
        
        disposeBag.insert (
            viewModel.output.isCountdown
                .observeOn(MainScheduler.instance)
                .map { $0 ? "Pause" : "Start" } //TODO: Translations
                .bind(to: timerButton.rx.title(for: .normal)),
            timerButton.rx.controlEvent(.touchUpInside)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    self?.viewModel.input.timerButtonTapped()
                }),
            doneButton.rx.controlEvent(.touchUpInside)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] _ in
                    self?.viewModel.input.doneButtonTapped()
                })
        )
    }
}

extension StepTableCell: XibMakeable {
    public typealias XibMakeableType = StepTableCell
}
