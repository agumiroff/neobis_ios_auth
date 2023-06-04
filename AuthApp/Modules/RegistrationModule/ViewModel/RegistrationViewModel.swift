//
//  RegistrationViewModel.swift
//  AuthApp
//
//  Created by G G on 04.06.2023.
//

import Foundation
import Combine

typealias RegViewModelOutput = RegistrationViewModelImpl.Output
typealias RegEvent = RegistrationViewEvents
typealias RegVMState = RegistrationViewModelImpl.State

protocol RegistrationViewModel {
    var state: AnyPublisher<RegVMState, Never> { get }
    var output: AnyPublisher<RegViewModelOutput, Never> { get }
    func sendEvent(_ event: RegEvent)
}
