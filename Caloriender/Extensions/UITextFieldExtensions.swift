//
//  UITextFieldExtensions.swift
//  Caloriender
//
//  Created by Uğur Güçer on 7.05.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit.UITextField

extension UITextField {
    func validateText(validationType: ValidationType) throws -> String{
        let validator = ValidationFactory.validateFor(type: validationType)
        return try validator.validate(self.text!)
    }
}
