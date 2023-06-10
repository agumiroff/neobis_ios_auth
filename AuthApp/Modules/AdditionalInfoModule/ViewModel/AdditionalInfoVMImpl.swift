//
//  AdditionalInfoVMImpl.swift
//  AuthApp
//
//  Created by G G on 05.06.2023.
//

import Foundation
import Combine
import Moya

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
    private let networkServiceProvider: MoyaProvider<NetworkRequest>
    var input: Input
    
    struct Input {}
    
    // MARK: - Init
    init(input: Input, networkServiceProvider: MoyaProvider<NetworkRequest>) {
        self.input = input
        self.networkServiceProvider = networkServiceProvider
    }
}

extension AdditionalInfoVMImpl {
    
    enum Event {
        case viewDidLoad
        case registerUser(UserModelAPI)
        case modalClosed
    }
    
    enum State {
        case initial
        case success(email: String)
        case failure(String)
    }
    
    enum Output {
        case additionalInfoAdded(UserModelAPI)
        case registerFailed
    }
    
    func sendEvent(_ event: AdditionalModuleEvent) {
        switch event {
        case let .registerUser(userModel):
            _output.send(.additionalInfoAdded(userModel))
        case .viewDidLoad:
            break
        case .modalClosed:
            _output.send(.registerFailed)
        }
    }
}
