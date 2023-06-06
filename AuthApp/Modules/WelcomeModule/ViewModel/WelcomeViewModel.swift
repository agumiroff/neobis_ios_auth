//
//  WelcomeViewModel.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import Combine

typealias WelcomeOutput = WelcomeViewModelImpl.OutputEvent
typealias WelcomeViewEvent = WelcomeViewController.Event

protocol WelcomeViewModel: AnyObject {
    associatedtype InputType
    var input: InputType { get set }
    var output: AnyPublisher<WelcomeOutput, Never> { get }
    func sendEvent(_ event: WelcomeViewEvent)
}
