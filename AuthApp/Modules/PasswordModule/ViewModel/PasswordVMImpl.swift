//
//  PasswordVMImpl.swift
//  AuthApp
//
//  Created by G G on 07.06.2023.
//

import Foundation
import Combine
import Moya

class PasswordVMImpl: PasswordVM {
    
    // MARK: - Properties
    var state: AnyPublisher<PasswordState, Never> {
        _state.eraseToAnyPublisher()
    }
    private var _state = CurrentValueSubject<PasswordState, Never>(.initial)
    var output: AnyPublisher<PasswordOutput, Never> {
        _output.eraseToAnyPublisher()
    }
    private var _output = PassthroughSubject<PasswordOutput, Never>()
    var input: Input
    private let networkServiceProvider: MoyaProvider<NetworkRequest>
    
    
    struct Input {
        let userModel: UserModelAPI
    }
    
    // MARK: - Init
    init(input: Input, networkServiceProvider: MoyaProvider<NetworkRequest>) {
        self.input = input
        self.networkServiceProvider = networkServiceProvider
    }
    
    private func registerUser(password: String) {
        let model = self.input.userModel
        networkServiceProvider.request(.register(model)) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                switch response.statusCode {
                case 200:
                    self.passwordSet(password: password) {result in
                        if result {
                            self._output.send(.userRegistered)
                            print("registered")
                        }
                    }
                default:
                    print("data=========\(response.statusCode)")
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func passwordSet(password: String,
                             completion: @escaping (Bool) -> Void) {
        networkServiceProvider.request(.passwordSet(password)) { result in
            switch result {
            case let .success(response):
                switch response.statusCode {
                case 200:
                    completion(true)
                default:
                    print("pass=========\(response)")
                }
            case .failure(_):
                completion(false)
            }
        }
    }
}

// MARK: - State and Event handling
extension PasswordVMImpl {
    enum Output {
        case backRouteAsked
        case userRegistered
    }
    
    enum Event {
        case goToPreviousScreen
        case registerUser(String)
    }
    
    enum State {
        case initial
    }
    
    func sendEvent(_ event: PasswordEvent) {
        switch event {
        case .goToPreviousScreen:
            _output.send(.backRouteAsked)
        case let .registerUser(password):
            registerUser(password: password)
        }
    }
}
