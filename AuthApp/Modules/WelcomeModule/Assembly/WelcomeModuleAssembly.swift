//
//  AssemblyBuilder.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import UIKit
import RxSwift

typealias WelcomeModule = (view: WelcomeViewController, output: Observable<WelcomeOutput>)

struct Dependencies {}

struct PayLoad {}

enum WelcomeModuleAssembly {
    static func buildModule(dependencies: Dependencies, payload: PayLoad) -> WelcomeModule {
        let viewModel = WelcomeViewModelImpl(input: .init())
        let view = WelcomeViewController(viewModel: viewModel)
        return (view, viewModel.output)
    }
}
