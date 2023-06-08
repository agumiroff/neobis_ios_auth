//
//  RegistrationViewModel.swift
//  AuthApp
//
//  Created by G G on 04.06.2023.
//

import Foundation
import Combine

typealias EmailVMOutput = EmailViewModelImpl.Output
typealias EmailEvent = EmailViewModelImpl.Event
typealias EmailVMState = EmailViewModelImpl.State

protocol EmailViewModel {
    var state: AnyPublisher<EmailVMState, Never> { get }
    var output: AnyPublisher<EmailVMOutput, Never> { get }
    func sendEvent(_ event: EmailEvent)
}
