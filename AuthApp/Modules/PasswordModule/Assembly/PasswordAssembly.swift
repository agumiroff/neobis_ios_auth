//
//  PasswordAssembly.swift
//  AuthApp
//
//  Created by G G on 07.06.2023.
//

import Foundation
import Combine
import Moya

typealias PasswordModule = (view: PasswordVC, output: AnyPublisher<PasswordOutput, Never>)

enum PasswordModuleAssembly {
    
    struct Dependencies {
        let networkServiceProvider = MoyaProvider<NetworkRequest>()
    }
    
    struct PayLoad {
        let userModel: UserModelAPI
    }
    
    static func buildModule(dependencies: Dependencies, payload: PayLoad) -> PasswordModule {
        let viewModel = PasswordVMImpl(input: .init(userModel: payload.userModel),
                                       networkServiceProvider: dependencies.networkServiceProvider)
        let view = PasswordVC(viewModel: viewModel)
        return (view, viewModel.output)
    }
}
