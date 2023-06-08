//
//  LoginViewModel.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import Combine

typealias LoginOutput = LoginVMImpl.OutputEvent

protocol LoginVM {
    associatedtype InputType
    var input: InputType { get set }
    var output: AnyPublisher<LoginOutput, Never> { get }
}
