//
//  RegistrationView.swift
//  AuthApp
//
//  Created by G G on 29.05.2023.
//

import Foundation
import SwiftUI

struct RegistrationView: View {
    private let viewModel: any RegistrationViewModel
    
    var body: some View {
        EmailView(viewModel: viewModel)
    }
    
    init(viewModel: any RegistrationViewModel) {
        self.viewModel = viewModel
    }
}
