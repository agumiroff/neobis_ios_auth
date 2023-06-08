//
//  LoginViewModelImpl.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import Combine

final class LoginVMImpl: LoginVM {
    
    // MARK: - Properties
    var state: AnyPublisher<LoginState, Never> {
        _state.eraseToAnyPublisher()
    }
    private var _state = CurrentValueSubject<LoginState, Never>(.initial)
    var output: AnyPublisher<LoginOutput, Never> { _output.eraseToAnyPublisher() }
    private var _output = PassthroughSubject<Output, Never>()
    var input: Input
    struct Input {}
    
    // MARK: - Init
    init(input: Input) {
        self.input = input
    }
}

extension LoginVMImpl {
    
    enum State {
        case initial
        case failure
    }
    
    enum Event {
        case askedForRecovery
        case askedForLogin
        case askedForReset
    }
    
    enum Output {
        case passwordRecovery
        case authenticateUser
    }
    
    func sendEvent(_ event: Event) {
        switch event {
        case .askedForRecovery:
            self._output.send(.passwordRecovery)
        case .askedForLogin:
            self._state.send(.failure)
        case .askedForReset:
            self._state.send(.initial)
        }
    }
}
