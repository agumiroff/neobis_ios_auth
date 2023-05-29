//
//  RegistrationView.swift
//  AuthApp
//
//  Created by G G on 29.05.2023.
//

import Foundation
import SwiftUI

struct EmailView: View {
    
    // MARK: - Properties
    @State var text = ""
    @State var textFieldPlaceholder = Constants.emailTextField
    @State var isTextFieldLabelHidden = true
    @State var textFieldLabel = ""
    private let viewModel: any RegistrationViewModel
    
    init(viewModel: any RegistrationViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            welcomeLabel()
            textFieldView()
            submitButton()
        }
        .padding(.horizontal, Constants.horizontalInsets)
    }
    
    // MARK: - WelcomeMessage
    @ViewBuilder
    func welcomeLabel() -> some View {
        ZStack {
            Text(Constants.welcomeLabelText)
                .font(Font.custom(Constants.Font.gothamMedium, size: Constants.Font.largeTitle))
                ._lineHeightMultiple(Constants.welcomeLabelLineHeight)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Image("smile")
                    .resizable()
                    .frame(width: Constants.imageSize, height: Constants.imageSize, alignment: .top)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .frame(maxHeight: .infinity, alignment: .top)
            }
            .frame(height: Constants.welcomeLabelHeight)
        }
        .foregroundColor(Color(hexString: Constants.mainBlueColor))
    }
    
    // MARK: - TextField
    @ViewBuilder
    func textFieldView() -> some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(hexString: Constants.inactiveGray))
                    .cornerRadius(Constants.textFieldCornerRadius)
                
                VStack {
                    if !isTextFieldLabelHidden {
                        Text(textFieldLabel)
                            .foregroundColor(Color(hexString: Constants.textDarkGray))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, Constants.smallTextLabelLeft)
                            .padding(.bottom, Constants.smallTextLabelBotton)
                            .font(Font.custom(Constants.Font.gothamMedium, size: Constants.Font.small))
                    }
                    
                    Text(textFieldPlaceholder)
                        .foregroundColor(Color(hexString: Constants.textDarkGray))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, Constants.smallTextLabelLeft)
                        .font(Font.custom(Constants.Font.gothamMedium, size: Constants.Font.regular))
                }
                
                TextField("", text: $text) { _ in
                    isTextFieldLabelHidden.toggle()
                    textFieldPlaceholder = isTextFieldLabelHidden ? Constants.emailTextField : ""
                    textFieldLabel = isTextFieldLabelHidden ? "" : Constants.emailTextField
                }
                .font(Font.custom(Constants.Font.gothamMedium, size: Constants.Font.regular))
                .padding(.leading, Constants.textFieldLeftInset)
            }
            .frame(height: Constants.textFieldHeight)
            .padding(.top, Constants.textFieldTop)
            
            Text(Constants.warningLabel)
                .foregroundColor(Color.red)
                .padding(16)
        }
    }
    
    // MARK: - Button
    @ViewBuilder
    func submitButton() -> some View {
        VStack {
            Button {
                viewModel.sendEvent(.checkEmail)
            } label: {
                Text(Constants.submitButtonLabel)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding([.top, .bottom], Constants.submitButtonInsets)
            }
            .foregroundColor(String.isValidEmail(text)() ? Color.white : Color(hexString: Constants.textDarkGray))
            .background(String.isValidEmail(text)() ? Color(hexString: Constants.mainBlueColor) :
                            Color(hexString: Constants.inactiveGray))
            .cornerRadius(Constants.submitButtonCornerRadius)
            .disabled(!String.isValidEmail(text)())
        }
        .padding(.top, Constants.submitButtonTop)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

fileprivate extension Constants {
    
    // Paddings
    static let imageSize = 80.0
    
    static let textFieldTop = 60.0
    static let textFieldHeight = 60.0
    static let textFieldCornerRadius = 8.0
    static let textFieldLeftInset = 10.0
    
    static let submitButtonTop = 31.0
    static let submitButtonCornerRadius = 16.0
    static let submitButtonInsets = 25.0
    
    static let smallTextLabelLeft = 10.0
    static let smallTextLabelBotton = 30.0
    
    static let welcomeLabelHeight = 159.0
    
    // Strings
    static let submitButtonLabel = "Далее"
    static let warningLabel = "Данная почта уже зарегистривана"
}
