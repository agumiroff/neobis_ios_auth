//
//  AdditionalInfoAssembly.swift
//  AuthApp
//
//  Created by G G on 06.06.2023.
//

import Foundation
import Combine
import Moya

typealias AdditionalInfoModule = (view: AdditionalInfoVC, output: AnyPublisher<AdditionalOutput, Never>)

enum AdditionalInfoModuleAssembly {
    
    struct Dependencies {
        let networkServiceProvider: MoyaProvider<NetworkRequest>
    }
    struct PayLoad {}
    
    static func buildModule(dependencies: Dependencies, payload: PayLoad) -> AdditionalInfoModule {
        let viewModel = AdditionalInfoVMImpl(input: .init(), networkServiceProvider: dependencies.networkServiceProvider)
        let view = AdditionalInfoVC(viewModel: viewModel)
        return (view, viewModel.output)
    }
}
