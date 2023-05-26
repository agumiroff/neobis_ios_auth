//
//  WelcomeViewModel.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation

protocol WelcomeViewModel {
    associatedtype InputType
    associatedtype OutputType
    var input: InputType { get set }
    var output: OutputType { get }
}
