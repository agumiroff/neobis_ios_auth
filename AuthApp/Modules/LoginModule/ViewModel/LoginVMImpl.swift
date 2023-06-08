//
//  LoginViewModelImpl.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import Combine

final class LoginVMImpl: LoginVM {
    
    var output: AnyPublisher<LoginOutput, Never> { _output.eraseToAnyPublisher() }
    private var _output = PassthroughSubject<LoginOutput, Never>()
    var input: Input
    struct Input {}
    
    init(input: Input) {
        self.input = input
    }
}

extension LoginVMImpl {
    enum OutputEvent {
        case passwordRecovery
        case authenticateUser
    }
}
