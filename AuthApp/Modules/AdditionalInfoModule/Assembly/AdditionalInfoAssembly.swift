//
//  AdditionalInfoAssembly.swift
//  AuthApp
//
//  Created by G G on 06.06.2023.
//

import Foundation
import Combine

typealias AdditionalInfoModule = (view: AdditionalInfoVC, output: AnyPublisher<AdditionalOutput, Never>)

enum AdditionalInfoModuleAssembly {
    
    struct Dependencies {}
    struct PayLoad {}
    
    static func buildModule(dependencies: Dependencies, payload: PayLoad) -> AdditionalInfoModule {
        let viewModel = AdditionalInfoVMImpl(input: .init())
        let view = AdditionalInfoVC(viewModel: viewModel)
        return (view, viewModel.output)
    }
}
