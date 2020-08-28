//
//  Extensions.swift
//  NIBM COVID19
//
//  Created by Chanuka on 8/28/20.
//  Copyright © 2020 NIBM. All rights reserved.
//

import UIKit

extension UITextField {
    func authTextField(withPlaceholder placeholder: String, isSecureTextEntry: Bool) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = .black
        textField.isSecureTextEntry = isSecureTextEntry
        textField.placeholder = placeholder
        
        return textField
    }
}
