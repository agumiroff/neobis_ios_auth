//
//  LoginViewModel.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import Combine

typealias LoginOutput = LoginVMImpl.Output
typealias LoginEvent = LoginVMImpl.Event
typealias LoginState = LoginVMImpl.State

protocol LoginVM {
    associatedtype InputType
    var input: InputType { get set }
    var output: AnyPublisher<LoginOutput, Never> { get }
    var state: AnyPublisher<LoginState, Never> { get }
    func sendEvent(_ event:LoginEvent)
}
