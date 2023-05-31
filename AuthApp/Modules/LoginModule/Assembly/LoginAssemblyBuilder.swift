//
//  LoginAssemblyBuilder.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import UIKit
import RxSwift

typealias LoginModule = (view: LoginViewController, output: Observable<LoginOutput>)

enum LoginModuleAssembly {
    
    struct Dependencies {}
    struct PayLoad {}
    
    static func buildModule(dependencies: Dependencies, payload: PayLoad) -> LoginModule {
        let viewModel = LoginViewModelImpl(input: .init())
        let view = LoginViewController(viewModel: viewModel)
        return (view, viewModel.output)
    }
}
