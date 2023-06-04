//
//  RegistrationModuleAssembly.swift
//  AuthApp
//
//  Created by G G on 29.05.2023.
//

import Foundation
import Combine
import Moya

typealias RegistrationModule = (view: RegistrationViewController, output: AnyPublisher<RegViewModelOutput, Never>)

enum RegistrationModuleAssembly {
    
    struct Dependencies {}
    struct PayLoad {}
    
    static func buildModule(dependencies: Dependencies, payload: PayLoad) -> RegistrationModule {
        let networkServiceProvider = MoyaProvider<NetworkRequest>()
        let viewModel = RegistrationViewModelImpl(input: .init(),
                                                  networkServiceProvider: networkServiceProvider)
        let view = RegistrationViewController(viewModel: viewModel)
        return (view, viewModel.output)
    }
}
