//
//  TokenStorage.swift
//  AuthApp
//
//  Created by G G on 07.06.2023.
//

import Foundation

class TokenStorage {
    let defaults = UserDefaults.standard
    static var shared = TokenStorage()
    
    var token: String {
        get {
            if let data = defaults.object(forKey: "token") as? String {
                return data
            } else {
                print("User defaults error")
                return ""
            }
        }
        
        set {
            defaults.set(newValue, forKey: "token")
        }
    }
}

// 99cxfi4lsm@ezztt.com
// Aa12345!
