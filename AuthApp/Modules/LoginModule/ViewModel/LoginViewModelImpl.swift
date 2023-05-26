//
//  LoginViewModelImpl.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation

final class LoginViewModelImpl: LoginViewModel {
    
    var output: ViewModelOutput
    var input: Input
    
    struct Input {
        
    }
    
    init(input: Input, output: ViewModelOutput) {
        self.input = input
        self.output = output
    }
}

extension LoginViewModelImpl {
    enum OutputEvent {
        case output
    }
}
