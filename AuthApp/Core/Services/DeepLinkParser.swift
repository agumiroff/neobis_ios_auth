//
//  DeepLinkParser.swift
//  AuthApp
//
//  Created by G G on 05.06.2023.
//

import Foundation
import UIKit

enum DeepLinkParser {
    
    static func parseDeepLink(_ url: URL) -> DeepLinkType? {
        print(url)
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let additionalInfo = components.host
            return DeepLinkType.allCases.first { $0.rawValue == additionalInfo }
        } else {
            return nil
        }
    }
}

enum DeepLinkType: String, CaseIterable {
    case additionalInfo
    case login
    
    static var allCases: [DeepLinkType] {
        return [.additionalInfo, .login]
    }
}

enum DeepLinkStructure {
    static var baseURL = "authapp"
}
