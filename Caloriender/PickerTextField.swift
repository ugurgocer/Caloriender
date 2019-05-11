//
//  genderPickerField.swift
//  Caloriender
//
//  Created by Uğur Güçer on 26.04.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit

extension UITextField{
    func loadDropdownData(data: [String]) {
        self.inputView = FieldPickerView.init(data: data, textField: self)
    }
}
