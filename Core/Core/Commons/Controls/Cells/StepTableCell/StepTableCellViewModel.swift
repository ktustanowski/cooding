//
//  StepTableCellViewModel.swift
//  Core
//
//  Created by Kamil Tustanowski on 27/07/2019.
//  Copyright © 2019 Kamil Tustanowski. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

public final class StepCellViewModel: StepCellViewModelProtocol, StepCellViewModelProtocolInputs, StepCellViewModelProtocolOutputs {
    public var input: StepCellViewModelProtocolInputs { return self }
    public var output: StepCellViewModelProtocolOutputs { return self }
    
    // MARK: - Inputs
    public func timerButtonTapped() {
        guard !isCountingDown else {
            stopCountdown()
            return
        }
        
        startCountdown()
    }
    
    public func doneButtonTapped() {
        isDoneRelay.accept(true)
        didTapDoneRelay.accept(())
    }
    
    // MARK: - Outputs
    public var title: Observable<String> {
        return .just(step.description)
    }
    
    public lazy var duration: Observable<String> = {
        return currentDuration?
            .observeOn(MainScheduler.instance)
            .compactMap { $0?.shortTime }
            .map { "\($0)" }
            .asObservable() ?? .empty()
    }()
    
    public lazy var endTime: Observable<String> = {
        return currentDuration?
            .observeOn(MainScheduler.instance)
            .compactMap { $0?.endTime }
            .map { "\($0)" }
            .asObservable() ?? .empty()
    }()
    
    public var isDurationAvailable: Observable<Bool> {
        return .just(step.duration != nil)
    }
    
    public lazy var didTapDone: Observable<Void> = {
        return didTapDoneRelay
            .observeOn(MainScheduler.instance)
            .asObservable()
    }()
    
    public lazy var isDone: Observable<Bool> = {
        return isDoneRelay
            .observeOn(MainScheduler.instance)
            .asObservable()
    }()
    
    public lazy var isCountdown: Observable<Bool> = {
        return isCountdownRelay
            .observeOn(MainScheduler.instance)
            .asObservable()
    }()
    
    // MARK: Implementation
    private let disposeBag = DisposeBag()
    private let step: Step
    private let isCountdownRelay = BehaviorRelay<Bool>(value: false)
    private let isDoneRelay = BehaviorRelay<Bool>(value: false)
    private let didTapDoneRelay = PublishRelay<Void>()
    private let currentDuration: BehaviorRelay<TimeInterval?>?

    private var timerDisposable: Disposable? {
        willSet {
            timerDisposable?.dispose()
        }
        didSet {
            isCountdownRelay.accept(timerDisposable != nil)
        }
    }
    
    public init(step: Step) {
        //TODO: Make sure didTapDoneSubject.dispose() on deinit is not needed
        self.step = step
        currentDuration = BehaviorRelay<TimeInterval?>(value: step.duration)
        
        currentDuration?
            .filter { $0 == 0 }
            .subscribe(onNext: { [weak self] _ in
                self?.timerDisposable?.dispose()
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        timerDisposable?.dispose()
    }
}

private extension StepCellViewModel {
    var isCountingDown: Bool {
        return timerDisposable != nil
    }
    
    func stopCountdown() {
        timerDisposable?.dispose()
        timerDisposable = nil
    }
    
    /// TODO: This will only work with regular app flow, not with app backgrounded, and the foregrounded etc.
    func startCountdown() {
        timerDisposable = Observable<Int>.timer(1.0, period: 1.0, scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let duration = self?.currentDuration?.value else { return }
                self?.currentDuration?.accept(duration - 1)
        }
    }
}

//TODO: MOVE
extension TimeInterval {
    var shortTime: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = self < .hours(1) ? [.minute, .second] : [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: self)
    }
    
    var endTime: String? {
        return Date(timeIntervalSinceNow: self).time
    }
}

extension TimeInterval {
    static func minutes(_ minutes: TimeInterval) -> TimeInterval {
        return 60.0 * minutes
    }
    
    static func hours(_ hours: TimeInterval) -> TimeInterval {
        return .minutes(60) * hours
    }
}

extension Date {
    var time: String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter.string(from: self)
    }
}
