//
//  Modal.swift
//  AuthApp
//
//  Created by G G on 01.06.2023.
//

import SwiftUI

struct ModalView: View {
    var notificationText: String
    weak var delegate: ModalViewDelegate?
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            ZStack {
                GeometryReader { geometry in
                    Rectangle()
                        .cornerRadius(Constants.rectangleRadius)
                        .foregroundColor(.white)
                        .frame(height: geometry.size.width)
                        .frame(maxHeight: .infinity, alignment: .center)
                }
                
                VStack {
                    Image(Constants.smileImageName)
                        .resizable()
                        .frame(maxWidth: Constants.smileImageMaxSize, maxHeight: Constants.smileImageMaxSize)
                    
                    Text(notificationText)
                        .padding(.top, Constants.notificationTextTop)
                        .padding(.horizontal, Constants.notificationTextHor)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        delegate?.closeModalView()
                    }) {
                        Text(Constants.buttonCloseText)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(Constants.buttonCornerRadius)
                    }
                    .padding(.horizontal, Constants.buttonHorPadding)
                    .padding([.top, .bottom], Constants.buttonTopPadding)
                }
            }
            .padding(.horizontal, Constants.zStackHorPadding)
        }
    }
    
    init(notificationText: String, delegate: ModalViewDelegate) {
        self.notificationText = notificationText
        self.delegate = delegate
    }
}

fileprivate extension Constants {
    
    // Constraints
    static let rectangleRadius = 32.0
    
    static let smileImageMaxSize = 120.0
    
    static let notificationTextTop = 24.0
    static let notificationTextHor = 16.0
    
    static let buttonCornerRadius = 10.0
    static let buttonHorPadding = 31.0
    static let buttonTopPadding = 41.0
    
    static let zStackHorPadding = 16.0
    
    // Strings
    
}
