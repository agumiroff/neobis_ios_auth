//
//  PasswordViewModel.swift
//  AuthApp
//
//  Created by G G on 07.06.2023.
//

import Foundation
import Combine

typealias PasswordOutput = PasswordVMImpl.Output
typealias PasswordState = PasswordVMImpl.State
typealias PasswordEvent = PasswordVMImpl.Event

protocol PasswordVM {
    associatedtype InputType
    var input: InputType { get set }
    var state: AnyPublisher<PasswordState, Never> { get }
    var output: AnyPublisher<PasswordOutput, Never> { get }
    func sendEvent(_ event: PasswordEvent)
}

protocol ViewModel {
    associatedtype InputType
    associatedtype Event
    associatedtype State
    associatedtype Output
    var input: InputType { get set }
    var state: AnyPublisher<State, Never> { get }
    var output: AnyPublisher<Output, Never> { get }
    func sendEvent(_ event: Event)
}
