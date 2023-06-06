//
//  AssemblyBuilder.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import UIKit
import Combine

typealias WelcomeModule = (view: WelcomeViewController, output: AnyPublisher<WelcomeOutput, Never>)

enum WelcomeModuleAssembly {
    
    struct Dependencies {}
    struct PayLoad {}
    
    static func buildModule(dependencies: Dependencies, payload: PayLoad) -> WelcomeModule {
        let viewModel = WelcomeViewModelImpl(input: .init())
        let view = WelcomeViewController(viewModel: viewModel)
        return (view, viewModel.output)
    }
}
