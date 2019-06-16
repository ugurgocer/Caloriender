//
//  UserUpdateViewController.swift
//  Caloriender
//
//  Created by Uğur Güçer on 7.05.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserUpdateViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var gender: UISwitch!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var targetWeightTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = UserDefaults.standard.string(forKey: "token")!
        AF.request("http://diyet.atwebpages.com/user/read/"+token, method: .get, parameters: nil).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    let result = JSON(json["result"].dictionaryValue)
                    
                    let data = ProfileInfo(username: result["username"].stringValue, name: result["name"].stringValue, surname: result["surname"].stringValue, height: result["height"].intValue, weight: result["weight"].intValue, targetWeight: result["target_weight"].intValue, age: result["age"].intValue, gender: result["gender"].intValue, email: result["email"].stringValue)
                    
                    self.nameTextField.text = data.name
                    self.surnameTextField.text = data.surname
                    self.emailTextField.text = data.email
                    self.ageTextField.text = String(data.age)
                    self.heightTextField.text = String(data.height)
                    self.weightTextField.text = String(data.weight)
                    self.targetWeightTextField.text = String(data.targetWeight)
                    self.usernameTextField.text = data.username
                    if(data.gender == 0){
                        self.gender.isOn = false
                    }else{
                        self.gender.isOn = true
                    }
                    
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

    }
    
    @IBAction func update(_ sender: Any) {
        do{
            let name = try nameTextField.validateText(validationType: .nameOrSurname)
            let surname = try surnameTextField.validateText(validationType: .nameOrSurname)
            let email = try emailTextField.validateText(validationType: .email)
            let username = try usernameTextField.validateText(validationType: .username)
            let gender = NSNumber(value: self.gender.isOn)
            let age = try ageTextField.validateText(validationType: .age)
            let targetWeight = try targetWeightTextField.validateText(validationType: .weight)
            let weight = try weightTextField.validateText(validationType: .weight)
            let height = try heightTextField.validateText(validationType: .height)
            
            let parameters: Parameters = [
                "name": name,
                "surname": surname,
                "email": email,
                "username": username,
                "gender": gender,
                "target_weight": targetWeight,
                "weight": weight,
                "age": age,
                "height": height
            ]
            
            let token = UserDefaults.standard.string(forKey: "token")!
            
            AF.request("http://diyet.atwebpages.com/user/update/"+token, method: .post, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["success"].boolValue {
                        _ = self.navigationController?.popViewController(animated: true)
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
