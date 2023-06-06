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


class EmailViewModelImpl: EmailViewModel {
    
    // MARK: - Properties
    var state: AnyPublisher<State, Never> {
        _state.eraseToAnyPublisher()
    }
    var output: AnyPublisher<EmailVMOutput, Never> {
        _output
            .eraseToAnyPublisher()
    }
    private lazy var _output = PassthroughSubject<Output, Never>()
    private lazy var _state = CurrentValueSubject<State, Never>(.initial)
    var input: Input
    private let networkServiceProvider: MoyaProvider<NetworkRequest>
    
    struct Input {}
    
    // MARK: - Init
    init(input: Input, networkServiceProvider: MoyaProvider<NetworkRequest>) {
        self.input = input
        self.networkServiceProvider = networkServiceProvider
    }
    
    private func validateEmail(_ email: String,
                               completion: @escaping (Bool) -> Void) {
        networkServiceProvider.request(.emailCheck(email)) { result in
            switch result {
            case let .success(response):
                switch response.statusCode {
                case 201:
                    print("dssds")
                    completion(true)
                case 400...410:
                    print("error")
                    completion(false)
                default:
                    print("default")
                    completion(false)
                }
            case let .failure(error):
                print(error)
                completion(false)
            }
        }
    }
}

extension EmailViewModelImpl {
    enum Output {
        case showPopUp(text: String)
        case popView
    }
    
    enum State: Equatable {
        case initial
        case emailCheckResult(Bool)
        case validationFailed
        case validationSuccess
    }
    
    func sendEvent(_ event: EmailModuleEvent) {
        handleEvent(event)
    }
    
    private func handleEvent(_ event: EmailModuleEvent) {
        switch event {
        case let .checkEmail(email):
            let result = email.isValidEmail()
            _state.send(.emailCheckResult(result))
        case .routeBack:
            _output.send(.popView)
        case let .validateEmail(email):
            validateEmail(email, completion: { [weak self] result in
                self?._state.send(result ? .validationSuccess : .validationFailed)
            })
        }
    }
}
