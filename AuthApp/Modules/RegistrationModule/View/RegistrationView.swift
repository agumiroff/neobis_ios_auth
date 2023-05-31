//
//  RegistrationView.swift
//  AuthApp
//
//  Created by G G on 29.05.2023.
//

import Foundation
import SwiftUI
import Combine

struct RegistrationView: View {
    @ObservedObject private var viewModel: RegistrationViewModel
    private var cancellable = Set<AnyCancellable>()
    
    var body: some View {
        switch viewModel.state {
        case .start:
            EmailView()
                .environmentObject(viewModel)
        case .emailValidationFailed:
            EmailView()
                .environmentObject(viewModel)
        case .loading:
            EmailView()
        case .waitForEmailInput:
            EmailView()
        case .emailSuccessfullyCreated:
            EmailView()
        }
    }
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
    }
}

extension RegistrationView {
    enum RegViewState {
        case start
        case validationFailed
    }
}

fileprivate extension Constants {
    static let warningLabel = "Данная почта уже зарегистривана"
}
