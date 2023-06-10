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
    case login(login: String, password: String)
    case logout
    case passwordReset(String)
    case passwordSet(String)
    case register(UserModelAPI)
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
        case .passwordSet:
            return Constants.passwordSet
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
        case .register, .passwordSet:
            return .put
        default:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .emailCheck(email):
            let parameters = ["email": email]
            return .requestParameters(parameters: parameters,
                                      encoding: JSONEncoding.default)
        case let .register(model):
            return .requestParameters(parameters: ["first_name": model.firstName,
                                                   "last_name": model.secondName,
                                                   "date_born": "2020-02-22",
                                                   "phone": model.phone],
                                      encoding: JSONEncoding.default)
        case let .passwordReset(email):
            return .requestParameters(parameters: ["email": email],
                                      encoding: JSONEncoding.default)
        case let .login(login, password):
            return .requestParameters(parameters: ["email": login,
                                                   "password": password],
                                      encoding: JSONEncoding.default)
        case let .passwordSet(password):
            return .requestParameters(parameters: ["password": password,
                                                   "confirm_password": password],
                                      encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        let token = TokenStorage.shared.token
        print("=====token ===== \(token)")
        switch self {
        case .emailCheck:
            return ["Content-Type": "application/json"]
        default:
            return ["Authorization": "Bearer \(token)"]
        }
    }
}

fileprivate extension Constants {
    // Strings
    static let urlString = "http://34.107.1.158"
    static let emailCheckPath = "/register-for-mobile/"
    static let loginPath = "/login/"
    static let logoutPath = "logout"
    static let passwordResetPath = "/password_reset/"
    static let passwordSet = "/password-update/"
    static let registerPath = "/register-update/"
    static let tokenPath = "token/refresh"
}
