//
//  RegistrationModuleAssembly.swift
//  AuthApp
//
//  Created by G G on 29.05.2023.
//

import Foundation
import Combine

typealias RegistrationModule = (view: RegistrationView, output: AnyPublisher<RegViewModelOutput, Error>)

enum RegistrationModuleAssembly {
    
    struct Dependencies {}
    struct PayLoad {}
    
    static func buildModule(dependencies: Dependencies, payload: PayLoad) -> RegistrationModule {
        let viewModel = RegistrationViewModel(input: .init())
        let view = RegistrationView(viewModel: viewModel)
        return (view, viewModel.output)
    }
}
