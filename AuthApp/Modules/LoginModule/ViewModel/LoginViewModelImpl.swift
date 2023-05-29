//
//  LoginViewModelImpl.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModelImpl: LoginViewModel {
    
    var output: Observable<LoginOutput> { _output.asObservable() }
    private var _output = PublishRelay<LoginOutput>()
    var input: Input
    struct Input {}
    
    init(input: Input) {
        self.input = input
    }
}

extension LoginViewModelImpl {
    enum OutputEvent {
        case passwordRecovery
        case authenticateUser
    }
}
