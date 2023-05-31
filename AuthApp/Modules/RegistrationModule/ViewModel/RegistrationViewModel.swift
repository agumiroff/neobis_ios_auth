//
//  RegistrationViewModelImpl.swift
//  AuthApp
//
//  Created by G G on 29.05.2023.
//

import Foundation
import SwiftUI
import Combine

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
    
    struct Input {}
    
    init(input: Input) {
        self.input = input
    }
}

extension RegistrationViewModel {
    enum Output {
        case emailCheckPassed
    }
    
    enum RegVMState: Equatable {
        case start
        case loading
        case waitForEmailInput(text: String)
        case emailValidationFailed
        case emailSuccessfullyCreated
    }
    
    func sendEvent(_ event: RegEvent) {
        handleEvent(event)
    }
    
    private func handleEvent(_ event: RegEvent) {
        switch event {
        case .checkEmail:
            state = .emailValidationFailed
        case .reset:
            state = .waitForEmailInput(text: "dsdss")
        }
    }
}

enum RegistrationViewEvents {
    case reset
    case checkEmail(email: String)
}
