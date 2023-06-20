//
//  PasswordAssembly.swift
//  AuthApp
//
//  Created by G G on 07.06.2023.
//

import Foundation
import Combine
import Moya

typealias PasswordModule = (view: PasswordVC<PasswordVMImpl>, output: AnyPublisher<PasswordOutput, Never>)

struct PasswordModuleAssembly {
        
    struct Dependencies {
        let networkServiceProvider: MoyaProvider<NetworkRequest>
    }
    
    struct PayLoad {
        let userModel: UserModelAPI
        let type: ViewControllerType
    }
    
    static func buildModule(dependencies: Dependencies, payload: PayLoad) -> PasswordModule {
        let viewModel = PasswordVMImpl(input: .init(userModel: payload.userModel),
                                       networkServiceProvider: dependencies.networkServiceProvider)
        let view = PasswordVC(viewModel: viewModel, type: payload.type)
        return (view, viewModel.output)
    }
}
