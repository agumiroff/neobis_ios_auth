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
