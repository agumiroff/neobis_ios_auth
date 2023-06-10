//
//  String + Extension.swift
//  AuthApp
//
//  Created by G G on 27.05.2023.
//

import Foundation

extension String {
    enum PasswordValidation {
        private static let passwordRegex = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{5,}$"
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
    
    func textFieldMasking(pattern: String) -> String {
        var result = ""
        var index = self.startIndex
        for char in pattern where index < self.endIndex {
            if char == "#" {
                result.append(self[index])
                index = self.index(after: index)
            } else {
                result.append(char)
            }
        }
        return result
    }
}
