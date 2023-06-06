//
//  RegistrationModuleAssembly.swift
//  AuthApp
//
//  Created by G G on 29.05.2023.
//

import Foundation
import Combine
import Moya

typealias RegistrationModule = (view: UIViewController, output: AnyPublisher<EmailVMOutput, Never>)

enum EmailModuleAssembly {
    
    struct Dependencies {}
    struct PayLoad {}
    
    static func buildModule(dependencies: Dependencies, payload: PayLoad) -> RegistrationModule {
        let networkServiceProvider = MoyaProvider<NetworkRequest>()
        let viewModel = EmailViewModelImpl(input: .init(),
                                                  networkServiceProvider: networkServiceProvider)
        let view = EmailVerificationVC(viewModel: viewModel)
        return (view, viewModel.output)
    }
}