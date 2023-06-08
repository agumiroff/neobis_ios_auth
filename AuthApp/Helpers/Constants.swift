//
//  Contants.swift
//  AuthApp
//
//  Created by G G on 24.05.2023.
//

import Foundation

enum Constants {
    
    enum Font {
        static let gothamMedium = "GothamPro-Medium"
        
        static let largeTitle = 40.0
        static let regular = 16.0
        static let small = 12.0
    }
    
    // Strings
    static let welcomeLabelText = "Смейся\nи улыбайся\nкаждый день"
    static let smileImageName = "smile"
    static let buttonCloseText = "Закрыть"
    static let notificationText = "На вашу почту\n «dojacat01.gmail.com» было отправлено письмо"
    static let loginFieldText = "Электронная почта"
    static let passwordFieldTitle = "Пароль"
    static let emailCheckFailed = "e-mail заполнен неверно"
    static let passCheckFailed = String("Пароль должен иметь длину не менее 8 символов.")
    
    // Colors
    static let mainBlueColor = "#5D5FEF"
    static let inactiveGray = "#F7F7F8"
    static let textDarkGray = "#9CA4AB"
    static let textWhite = "#FFFFFF"
    
    // Constraints
    static let horizontalInsets = 20.0
    static let submitButtonCornerRadius = 16.0
    static let welcomeLabelLineHeight = 1.25
    
    static let hidePasswordButtonTrailing = 12.0
    static let hidePasswordButtonTop = 30.0
    static let hidePasswordButtonBottom = 14.0
    
    // Names
    static let hidePasswordImage = "passHide"
    static let hiddenPasswordImage = "passHidden"
}
