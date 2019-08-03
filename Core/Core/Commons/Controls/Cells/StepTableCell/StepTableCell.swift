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
    @IBOutlet weak var containerView: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        containerView.roundCorners(radius: 10) //TODO: Make a constant or sth
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        descriptionLabel.text = nil
        counterLabel.text = nil
        endLabel.text = nil
        timerButton.setTitle(nil, for: .normal)
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
        viewModel.output.isDurationAvailable
            .observeOn(MainScheduler.instance)
            .map { !$0 }
            .bind(to: durationControlsContainer.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.title
            .observeOn(MainScheduler.instance)
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.duration
            .observeOn(MainScheduler.instance)
            .bind(to: counterLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.endTime
            .observeOn(MainScheduler.instance)
            .bind(to: endLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.isCountdown
            .observeOn(MainScheduler.instance)
            .map { $0 ? "Pause" : "Start" } //TODO: Translations
            .bind(to: timerButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        timerButton.rx.controlEvent(.touchUpInside)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.input.timerButtonTapped()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.currentDuration
            .observeOn(MainScheduler.instance)
            .map { $0 == 0 }
            .bind(to: timerButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        doneButton.rx.controlEvent(.touchUpInside)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.input.doneButtonTapped()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isDone
            .filter { $0 == true }
            .subscribe { [weak self] _ in
//                self?.doneButton.setTitle("DoneDSS", for: .normal) //TODO: Translate
//                self?.doneButton.setTitle(nil, for: .normal)
                self?.doneButton.setImage(UIImage(named: "backArrow"), for: .normal)
//                self?.doneButton.isEnabled = false
            }
            .disposed(by: disposeBag)
        
        viewModel.output.isDone
            .filter { $0 == false }
            .subscribe { [weak self] _ in
//                self?.doneButton.setTitle("DoneSSS", for: .normal) //TODO: Translate
                self?.doneButton.setImage(nil, for: .normal)
            }
            .disposed(by: disposeBag)
    }
}

extension StepTableCell: XibMakeable {
    public typealias XibMakeableType = StepTableCell
}
