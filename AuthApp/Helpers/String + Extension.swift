//
//  String + Extension.swift
//  AuthApp
//
//  Created by G G on 27.05.2023.
//

import Foundation

extension String {
    enum PasswordValidation {
        private static let passwordRegex = "^[a-zA-Z0-9]{8,}$"
        static let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    }
    
    func isValidPassword() -> Bool {
        return PasswordValidation.passwordPredicate.evaluate(with: self)
    }
    
    enum EmailValidation {
        private static let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        static let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    }
    
    func isValidEmail() -> Bool {
        return EmailValidation.emailPredicate.evaluate(with: self)
    }
}