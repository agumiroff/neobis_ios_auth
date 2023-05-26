//
//  Coordinator.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: Navigation { get set }
    func start()
}
