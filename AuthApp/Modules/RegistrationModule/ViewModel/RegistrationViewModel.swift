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

typealias RegViewModelOutput = RegistrationViewModel.Output
typealias RegEvent = RegistrationViewEvents
typealias RegVMState = RegistrationViewModel.RegVMState
typealias RegViewState = RegistrationView.RegViewState

class RegistrationViewModel: ObservableObject {
    var output: AnyPublisher<RegViewModelOutput, Error> {
        _output
            .eraseToAnyPublisher()
    }
    private var _output = PassthroughSubject<RegViewModelOutput, Error>()
    @Published private(set) var state: RegVMState = .start
    var input: Input
    private let networkServiceProvider: MoyaProvider<NetworkRequest>
    
    struct Input {}
    
    init(input: Input, networkServiceProvider: MoyaProvider<NetworkRequest>) {
        self.input = input
        self.networkServiceProvider = networkServiceProvider
    }
    
    private func validateEmail() {
        networkServiceProvider.request(.emailCheck) { result in
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

extension RegistrationViewModel {
    enum Output {
        case emailCheckPassed
        case showPopUp(text: String)
        case popView
    }
    
    enum RegVMState: Equatable {
        case start
        case loading
        case waitForEmailInput
        case emailValidationFailed
        case emailSuccessfullyCreated
    }
    
    func sendEvent(_ event: RegEvent) {
        handleEvent(event)
    }
    
    private func handleEvent(_ event: RegEvent) {
        switch event {
        case .checkEmail:
            validateEmail()
            state = .emailValidationFailed
        case .routeBack:
            _output.send(.popView)
        case .reset:
            state = .waitForEmailInput
        }
    }
}

enum RegistrationViewEvents {
    case checkEmail(email: String)
    case routeBack
    case reset
}
