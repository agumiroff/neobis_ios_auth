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
        setOutput(event)
    }
    
    private func setOutput(_ event: WelcomeViewEvent) {
        switch event {
        case .loginButtonTapped:
            _output.accept(.routeToLogin)
        case .registerButtonTapped:
            _output.accept(.registerNewUser)
        }
    }
}
