//
//  RegistrationViewModel.swift
//  AuthApp
//
//  Created by G G on 29.05.2023.
//

import Foundation
import Combine

typealias RegViewModelOutput = RegistrationViewModelImpl.Output
typealias RegEvent = RegistrationViewEvents
typealias RegState = RegistrationViewModelImpl.State

protocol RegistrationViewModel {
    associatedtype InputType
    var input: InputType { get set }
    var state: AnyPublisher<RegState, Error> { get }
    var output: AnyPublisher<RegViewModelOutput, Error> { get }
    func sendEvent(_ event: RegEvent)
}

enum RegistrationViewEvents {
    case checkEmail
}
