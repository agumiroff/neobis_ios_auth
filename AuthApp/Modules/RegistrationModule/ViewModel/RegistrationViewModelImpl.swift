//
//  RegistrationViewModelImpl.swift
//  AuthApp
//
//  Created by G G on 29.05.2023.
//

import Foundation
import Combine

class RegistrationViewModelImpl: RegistrationViewModel {
    
    var output: AnyPublisher<RegViewModelOutput, Error> {
        _output
            .eraseToAnyPublisher()
    }
    private var _output = PassthroughSubject<RegViewModelOutput, Error>()
    var state: AnyPublisher<RegState, Error> {
        _state.eraseToAnyPublisher()
    }
    private var _state = PassthroughSubject<RegState, Error>()
    var input: Input
    
    struct Input {}
    
    init(input: Input) {
        self.input = input
    }
}

extension RegistrationViewModelImpl {
    enum Output {
        case emailCheckPassed
    }
    
    enum State {}
    
    func sendEvent(_ event: RegEvent) {
        handleEvent(event)
    }
    func setState(_ state: State) {}
    
    private func handleEvent(_ event: RegEvent) {
        switch event {
        case .checkEmail:
            _output.send(.emailCheckPassed)
        }
    }
}
