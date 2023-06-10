//
//  UserModelAPI.swift
//  AuthApp
//
//  Created by G G on 07.06.2023.
//

import Foundation

struct UserModelAPI {
    var firstName: String
    var secondName: String
    var dateOfBirth: String
    var phone: String
    
    private enum CodingKeys: String, CodingKey {
            case firstName = "first_name"
            case secondName = "last_name"
            case dateOfBirth = "date_born"
    }
}
