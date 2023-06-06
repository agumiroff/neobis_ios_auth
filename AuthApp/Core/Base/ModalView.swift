//
//  ModalView.swift
//  AuthApp
//
//  Created by G G on 05.06.2023.
//

import Foundation
import UIKit

final class ModalView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let squarePath = UIBezierPath(roundedRect: bounds,
                                      cornerRadius: 32)
        squarePath.lineWidth = 2.0
        UIColor.white.setFill()
        squarePath.fill()
    }
}
