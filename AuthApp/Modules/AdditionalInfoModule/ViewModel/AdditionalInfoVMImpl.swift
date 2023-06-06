//
//  AdditionalInfoVMImpl.swift
//  AuthApp
//
//  Created by G G on 05.06.2023.
//

import Foundation
import Combine

class AdditionalInfoVMImpl: AdditionalInfoVM {
    
    // MARK: - Properties
    var state: AnyPublisher<State, Never> {
        _state.eraseToAnyPublisher()
    }
    var output: AnyPublisher<Output, Never> {
        _output.eraseToAnyPublisher()
    }
    private lazy var _output = PassthroughSubject<Output, Never>()
    private lazy var _state = CurrentValueSubject<State, Never>(.initial)
    var input: Input
    
    struct Input {}
    
    // MARK: - Init
    init(input: Input) {
        self.input = input
    }
}

extension AdditionalInfoVMImpl {
    
    enum Event {
        case checkAllFilled
        case registerUser(firstName: String, secondName: String, dateOfBirth: String, email: String)
    }
    
    enum State {
        case initial
    }
    
    enum Output {
        case additionalInfoAdded(firstName: String, secondName: String, dateOfBirth: String, email: String)
    }
    
    func sendEvent(_ event: AdditionalModuleEvent) {
        switch event {
        case .checkAllFilled:
            break
        case let .registerUser(irstName, secondName, dateOfBirth, email):
            _output.send(.additionalInfoAdded(firstName: irstName,
                                              secondName: secondName,
                                              dateOfBirth: dateOfBirth,
                                              email: email))
        }
    }
}
