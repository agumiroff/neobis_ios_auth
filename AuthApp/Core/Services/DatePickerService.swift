//
//  DatePickerService.swift
//  AuthApp
//
//  Created by G G on 06.06.2023.
//

import Foundation
import UIKit

enum DatePickerService {
    
    static func presentDatePicker(_ from: UIViewController) {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.date = NSDate.now
        
        let modalView = UIViewController()
        modalView.view = picker
        
        modalView.modalPresentationStyle = .formSheet
        
        from.present(modalView, animated: true)
    }
}
