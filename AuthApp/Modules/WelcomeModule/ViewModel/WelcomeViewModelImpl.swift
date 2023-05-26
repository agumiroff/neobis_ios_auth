//
//  WelcomeViewModelImpl.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation


final class WelcomeViewModelImpl: WelcomeViewModel {
    var output: OutputEvent
    var input: Input
    
    struct Input {
        
    }
    
    init(input: Input, output: OutputEvent) {
        self.input = input
        self.output = output
    }
}

extension WelcomeViewModelImpl {
    enum OutputEvent {
        case output
    }
}
