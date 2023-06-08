//
//  TokenStorage.swift
//  AuthApp
//
//  Created by G G on 07.06.2023.
//

import Foundation

class TokenStorage {
    static var shared = TokenStorage()
    
    var token: String = ""
}
