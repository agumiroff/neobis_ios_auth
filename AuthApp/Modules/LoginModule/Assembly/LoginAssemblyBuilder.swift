//
//  LoginAssemblyBuilder.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import UIKit
import Combine
import Moya

typealias LoginModule = (view: LoginVC, output: AnyPublisher<LoginOutput, Never>)

enum LoginModuleAssembly {
    
    struct Dependencies {
        let networkServiceProvider: MoyaProvider<NetworkRequest>
    }
    struct PayLoad {}
    
    static func buildModule(dependencies: Dependencies, payload: PayLoad) -> LoginModule {
        let viewModel = LoginVMImpl(input: .init(), networkServiceProvider: dependencies.networkServiceProvider)
        let view = LoginVC(viewModel: viewModel)
        return (view, viewModel.output)
    }
}
