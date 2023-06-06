//
//  AdditionalInfoVM.swift
//  AuthApp
//
//  Created by G G on 05.06.2023.
//

import Foundation
import Combine

typealias AdditionalOutput = AdditionalInfoVMImpl.Output
typealias AdditionalState = AdditionalInfoVMImpl.State
typealias AdditionalModuleEvent = AdditionalInfoVMImpl.Event

protocol AdditionalInfoVM {
    var state: AnyPublisher<AdditionalState, Never> { get }
    var output: AnyPublisher<AdditionalOutput, Never> { get }
    func sendEvent(_ event: AdditionalModuleEvent)
}
