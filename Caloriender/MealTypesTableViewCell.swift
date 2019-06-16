//
//  MealTypesTableViewCell.swift
//  Caloriender
//
//  Created by Uğur Güçer on 16.06.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MealTypesTableViewCell: UITableViewCell {
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var mealType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func edit(_ sender: UIButton) {
        UserDefaults.standard.set(self.tag, forKey: "meal_type_id")
    }
    @IBAction func showDetail(_ sender: UIButton) {
        UserDefaults.standard.set(self.tag, forKey: "meal_id")
    }
}
