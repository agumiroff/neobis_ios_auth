//
//  Navigation.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import UIKit

protocol Navigation: UINavigationController {
    var coordinator: Coordinator? { get set }
}
