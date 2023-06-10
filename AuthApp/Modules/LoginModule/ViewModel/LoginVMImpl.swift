//
//  LoginViewModelImpl.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import Combine
import Moya

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
    let networkServiceProvider: MoyaProvider<NetworkRequest>
    
    // MARK: - Init
    init(input: Input, networkServiceProvider: MoyaProvider<NetworkRequest>) {
        self.input = input
        self.networkServiceProvider = networkServiceProvider
    }
    
    private func loginUser(login: String,
                           password: String,
                           completion: @escaping (Bool) -> Void) {
        networkServiceProvider.request(.login(login: login, password: password)) { result in
            switch result {
            case let .success(response):
                let statusCode = response.statusCode
                if statusCode == 200 {
                    completion(true)
                } else {
                    print("Registration failed. Please try again.")
                    completion(false)
                }
            case let .failure(error):
                completion(false)
                print("Registration failed: \(error.localizedDescription)")
            }
        }
    }
}

extension LoginVMImpl {
    
    enum State {
        case initial
        case failure
    }
    
    enum Event {
        case askedForRecovery
        case askedForLogin(login: String, password: String)
        case askedForReset
    }
    
    enum Output {
        case passwordRecovery
        case authenticateUser
        case userSucessfullyLogedIn
    }
    
    func sendEvent(_ event: Event) {
        switch event {
        case .askedForRecovery:
            self._output.send(.passwordRecovery)
        case let .askedForLogin(login, password):
            loginUser(login: login, password: password,
                      completion: { [weak self] result in
                guard let self else { return }
                if result {
                    self._output.send(.userSucessfullyLogedIn)
                } else {
                    self._state.send(.failure)
                }
            })
        case .askedForReset:
            self._state.send(.initial)
        }
    }
}
