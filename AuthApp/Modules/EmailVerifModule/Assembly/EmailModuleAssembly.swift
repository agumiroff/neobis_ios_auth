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
    
    struct Dependencies {
        let networkServiceProvider = MoyaProvider<NetworkRequest>()
    }
    
    struct PayLoad {
        let type: ViewControllerType
    }
    
    static func buildModule(dependencies: Dependencies, payload: PayLoad) -> RegistrationModule {
        let viewModel = EmailViewModelImpl(input: .init(),
                                           networkServiceProvider: dependencies.networkServiceProvider)
        let view = EmailVerificationVC(viewModel: viewModel, type: payload.type)
        return (view, viewModel.output)
    }
}
