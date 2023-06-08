//
//  DeepLinkParser.swift
//  AuthApp
//
//  Created by G G on 05.06.2023.
//

import Foundation
import UIKit
import Combine

typealias Parameters = [String: String]

final class DeepLinkParser {
    
    // MARK: - Properties
    static let shared = DeepLinkParser()
    var currentDeepLink: AnyPublisher<DeepLinkModel?, Never> {
        currentDeepLinkTrigger.eraseToAnyPublisher()
    }
    private let currentDeepLinkTrigger = CurrentValueSubject<DeepLinkModel?, Never>(nil)
    
    // MARK: - Init
    private init() {}
    
    func parseDeepLink(_ url: URL) {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var parameters = Parameters()
            let host = components.host ?? ""
            let components = url.pathComponents.filter({ $0.count > 1 })
            if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
                for queryItem in queryItems {
                    let name = queryItem.name
                    let value = queryItem.value
                    parameters[name] = value
                }
            }
            
            let model = DeepLinkModel(host: host, components: components, parameters: parameters)
            print(model)
            currentDeepLinkTrigger.send(model)
        }
    }
}

struct DeepLinkModel {
    let host: String
    let components: [String]
    let parameters: Parameters
}
