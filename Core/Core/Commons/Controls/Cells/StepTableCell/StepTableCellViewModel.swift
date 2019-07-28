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
    public let title: Observable<String>
    public let duration: Observable<String>
    public let endTime: Observable<String>
    public let isDurationAvailable: Observable<Bool>
    public let didTapDone: Observable<Void>
    public let isDone: Observable<Bool>
    public let isCountdown: Observable<Bool>
    
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
        title = .just(step.description)
        isDurationAvailable = .just(step.duration != nil)
        
        duration = currentDuration?
            .observeOn(MainScheduler.instance)
            .compactMap { $0?.shortTime }
            .map { "\($0)" }
            .asObservable() ?? .empty()
        
        endTime = currentDuration?
            .observeOn(MainScheduler.instance)
            .compactMap { $0?.endTime }
            .map { "\($0)" }
            .asObservable() ?? .empty()
        
        didTapDone = didTapDoneRelay
            .observeOn(MainScheduler.instance)
            .asObservable()
        
        isDone = isDoneRelay
            .observeOn(MainScheduler.instance)
            .asObservable()
        
        isCountdown = isCountdownRelay
            .observeOn(MainScheduler.instance)
            .asObservable()

        let durationReachedZero = currentDuration?.filter { $0 == 0 }
        durationReachedZero?
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
