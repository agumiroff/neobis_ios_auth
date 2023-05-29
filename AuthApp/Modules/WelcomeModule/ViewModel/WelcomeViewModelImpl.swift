//
//  WelcomeViewModelImpl.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class WelcomeViewModelImpl: WelcomeViewModel {
    
    private lazy var _output = PublishRelay<WelcomeOutput>()
    var output: Observable<WelcomeOutput> { _output.asObservable() }
    var input: Input
    struct Input {}
    
    init(input: Input) {
        self.input = input
    }
}

extension WelcomeViewModelImpl {
    enum OutputEvent {
        case routeToLogin
        case registerNewUser
    }
    
    func sendEvent(_ event: WelcomeViewEvent) {
        handleEvent(event)
    }
    
    private func handleEvent(_ event: WelcomeViewEvent) {
        switch event {
        case .loginButtonTapped:
            setOutput(.routeToLogin)
        case .registerButtonTapped:
            setOutput(.registerNewUser)
        }
    }
    
    private func setOutput(_ event: OutputEvent) {
        _output.accept(event)
    }
}
