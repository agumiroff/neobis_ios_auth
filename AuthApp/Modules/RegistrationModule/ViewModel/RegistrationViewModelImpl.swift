//
//  RegistrationViewModelImpl.swift
//  AuthApp
//
//  Created by G G on 29.05.2023.
//

import Foundation
import SwiftUI
import Combine
import Moya


class RegistrationViewModelImpl: RegistrationViewModel {
    var state: AnyPublisher<State, Never> {
        _state.eraseToAnyPublisher()
    }
    
    var output: AnyPublisher<RegViewModelOutput, Never> {
        _output
            .eraseToAnyPublisher()
    }
    private lazy var _output = PassthroughSubject<Output, Never>()
    private lazy var _state = CurrentValueSubject<State, Never>(.initial)
    var input: Input
    private let networkServiceProvider: MoyaProvider<NetworkRequest>
    
    struct Input {}
    
    init(input: Input, networkServiceProvider: MoyaProvider<NetworkRequest>) {
        self.input = input
        self.networkServiceProvider = networkServiceProvider
    }
    
    private func validateEmail(_ email: String) {
        networkServiceProvider.request(.emailCheck(email)) { result in
            switch result {
            case .success(_):
                print(result)
            case .failure(_):
                print("error")
            }
        }
    }
    
    private func registerEmail() {}
}

extension RegistrationViewModelImpl {
    enum Output {
        case emailCheckPassed
        case showPopUp(text: String)
        case popView
    }
    
    enum State: Equatable {
        case initial
        case loading
        case waitForEmailInput
        case emailValidationFailed
        case emailCheckSuccessfull
        case emailCheckFailed
    }
    
    func sendEvent(_ event: RegEvent) {
        handleEvent(event)
    }
    
    private func handleEvent(_ event: RegEvent) {
        switch event {
        case let .checkEmail(email):
            let result = email.isValidEmail()
            _state.send(result ? .emailCheckSuccessfull : .emailCheckFailed)
        case .routeBack:
            _output.send(.popView)
        case .reset:
            _state.send(.initial)
        case let .validateEmail(email):
            validateEmail(email)
        }
    }
}

enum RegistrationViewEvents {
    case checkEmail(email: String)
    case validateEmail(email: String)
    case routeBack
    case reset
}
