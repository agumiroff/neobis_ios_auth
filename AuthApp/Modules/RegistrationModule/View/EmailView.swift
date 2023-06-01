//
//  RegistrationView.swift
//  AuthApp
//
//  Created by G G on 29.05.2023.
//

import Foundation
import SwiftUI
import Combine

struct EmailView: View {
    
    // MARK: - Properties
    @State private var isFocused = false
    @State private var errorMessage = ""
    @EnvironmentObject var viewModel: RegistrationViewModel
    @ObservedObject var textManager = TextFieldManager()
    @State var isEmailCreated = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                welcomeLabel()
                textFieldView()
                submitButton()
            }
            .padding(.horizontal, Constants.horizontalInsets)
            .navigationBarTitle(Constants.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                viewModel.sendEvent(.routeBack)
            }) {
                Image(systemName: "arrow.left")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black)
                    .background(Color(hexString: Constants.inactiveGray))
                    .cornerRadius(50)
            })
        }
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
                Image(Constants.smileImageName)
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
            
            VStack {
                TextField("", text: $textManager.text) { focused in
                    withAnimation(.easeInOut) {
                        isFocused = focused ? true : false
                    }
                }
                .onTapGesture {
                    if viewModel.state == .emailValidationFailed {
                        viewModel.sendEvent(.reset)
                    }
                }
                .foregroundColor(.black)
                .background(
                    
                    Text(Constants.emailTextField)
                        .scaleEffect(isFocused ? 0.8 : 1)
                        .offset(x: isFocused ? -15 : 0, y: isFocused ? -18 : 0)
                    , alignment: .leading
                )
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(viewModel.state == .emailValidationFailed ? .red : Color.clear, lineWidth: 1)
            )
            .background(Color(hexString: Constants.inactiveGray))
            .cornerRadius(16)
            .font(Font.custom(Constants.Font.gothamMedium, size: Constants.Font.regular))
            .foregroundColor(Color(hexString: Constants.textDarkGray))
            
            
            if viewModel.state == .emailValidationFailed {
                Text(Constants.errorMessage)
                    .foregroundColor(Color.red)
                    .padding(.top, 16)
            }
        }
        .padding(.top, Constants.textFieldTop)
    }
    
    // MARK: - Button
    @ViewBuilder
    func submitButton() -> some View {
        VStack {
            Button {
                viewModel.sendEvent(.checkEmail(email: textManager.text))
            } label: {
                Text(Constants.submitButtonLabel)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding([.top, .bottom], Constants.submitButtonInsets)
            }
            .foregroundColor(String.isValidEmail(textManager.text)() ? Color.white :
                                Color(hexString: Constants.textDarkGray))
            .background(String.isValidEmail(textManager.text)() ? Color(hexString: Constants.mainBlueColor) :
                            Color(hexString: Constants.inactiveGray))
            .cornerRadius(Constants.submitButtonCornerRadius)
            .disabled(!String.isValidEmail(textManager.text)())
        }
        .padding(.top, Constants.submitButtonTop)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

class TextFieldManager: ObservableObject {
    
    @Published var text = "" {
        didSet {
            if text.count > 25 && oldValue.count <= 25 {
                text = oldValue
            }
        }
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
    static let errorMessage = "Данный email уже существует"
    static let navigationTitle = "Регистрация"
}
