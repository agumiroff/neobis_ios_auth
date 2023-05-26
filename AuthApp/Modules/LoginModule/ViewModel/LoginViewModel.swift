//
//  LoginViewModel.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation

typealias ViewModelOutput = LoginViewModelImpl.OutputEvent

protocol LoginViewModel {
    associatedtype InputType
    var input: InputType { get set }
    var output: ViewModelOutput { get }
}
