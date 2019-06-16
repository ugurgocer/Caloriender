//
//  CalculateViewController.swift
//  Caloriender
//
//  Created by Uğur Güçer on 15.06.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BasalMetabolismViewController: UIViewController {

    @IBOutlet weak var gender: UISwitch!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func calculate(_ sender: Any) {
        do{
            let genderValue = NSNumber(value: self.gender.isOn)
            let ageValue = try age.validateText(validationType: .age)
            let weightValue = try weight.validateText(validationType: .weight)
            let heightValue = try height.validateText(validationType: .height)
            
            let parameters: Parameters = [
                "gender": genderValue,
                "weight": weightValue,
                "age": ageValue,
                "height": heightValue
            ]
            
            let token = UserDefaults.standard.string(forKey: "token")!
            
            AF.request("http://diyet.atwebpages.com/calculate/basal-metabolism/"+token, method: .post, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["success"].boolValue {
                        let data = JSON(json["result"].dictionaryValue)
                        
                        self.result.text = "Bazal Metabolizma Hızınız: "+data["basal-metabolism"].stringValue + " kcal"
                    } else {
                        let alertController = UIAlertController(title: nil, message: json["error"].stringValue, preferredStyle: UIAlertController.Style.alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } catch(let error){
            let alertController = UIAlertController(title: nil, message: (error as! ValidationError).message, preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
