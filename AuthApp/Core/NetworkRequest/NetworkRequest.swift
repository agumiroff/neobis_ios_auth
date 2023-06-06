//
//  NetworkService.swift
//  AuthApp
//
//  Created by G G on 01.06.2023.
//

import Foundation
import Moya

enum NetworkRequest {
    case emailCheck(String)
    case login
    case logout
    case passwordReset
    case passwordResetConfirm
    case register
    case refreshToken
}

extension NetworkRequest: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.urlString) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .emailCheck:
            return Constants.emailCheckPath
        case .login:
            return Constants.loginPath
        case .logout:
            return Constants.logoutPath
        case .passwordReset:
            return Constants.passwordResetPath
        case .passwordResetConfirm:
            return Constants.passwordResetConfirmPath
        case .register:
            return Constants.registerPath
        case .refreshToken:
            return Constants.tokenPath
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .emailCheck:
            return .post
        default:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .emailCheck(email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}

fileprivate extension Constants {
    // Strings
    static let urlString = "http://34.107.1.158"
    static let emailCheckPath = "/auth/register/"
    static let loginPath = "login"
    static let logoutPath = "logout"
    static let passwordResetPath = "password_reset"
    static let passwordResetConfirmPath = "password_reset_confirm"
    static let registerPath = "register"
    static let tokenPath = "token/refresh"
}
