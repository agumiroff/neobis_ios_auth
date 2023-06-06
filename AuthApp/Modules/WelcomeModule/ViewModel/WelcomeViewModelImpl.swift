//
//  WelcomeViewModelImpl.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import Combine

final class WelcomeViewModelImpl: WelcomeViewModel {
    
    private lazy var _output = PassthroughSubject<WelcomeOutput, Never>()
    var output: AnyPublisher<WelcomeOutput, Never> { _output.eraseToAnyPublisher() }
    var input: Input
    struct Input {}
    
    init(input: Input) {
        self.input = input
    }
}

extension WelcomeViewModelImpl {
    enum OutputEvent {
        case signInUser
        case signUpUser
    }
    
    func sendEvent(_ event: WelcomeViewEvent) {
        handleEvent(event)
    }
    
    private func handleEvent(_ event: WelcomeViewEvent) {
        switch event {
        case .signInButtonTapped:
            setOutput(.signInUser)
        case .signUnButtonTapped:
            setOutput(.signUpUser)
        }
    }
    
    private func setOutput(_ event: OutputEvent) {
        _output.send(event)
    }
}
