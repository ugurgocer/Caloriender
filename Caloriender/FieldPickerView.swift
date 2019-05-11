//
//  FieldPickerView.swift
//  Caloriender
//
//  Created by Uğur Güçer on 26.04.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit

class FieldPickerView : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: - Variables
    var data: [String]!
    var textField: UITextField!
    
    init(data: [String], textField: UITextField){
        super.init(frame: CGRect(x: 0, y:0, width: 200, height: 1))
        
        self.data = data
        self.textField = textField
        
        self.delegate = self
        self.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.endEditing(true)
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = data[row]
        
        self.isHidden = true
    }
}
