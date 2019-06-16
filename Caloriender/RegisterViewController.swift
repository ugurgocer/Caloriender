//
//  RegisterViewController.swift
//  Caloriender
//
//  Created by Uğur Güçer on 24.04.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController{
    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var genderSelectItem: UISwitch!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var targetWeightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    //MARK: - Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction func register(_ sender: Any) {
        do{
            let name = try nameTextField.validateText(validationType: .nameOrSurname)
            let surname = try surnameTextField.validateText(validationType: .nameOrSurname)
            let email = try emailTextField.validateText(validationType: .email)
            let pass = try passwordTextField.validateText(validationType: .password)
            let username = try usernameTextField.validateText(validationType: .username)
            let gender = NSNumber(value: genderSelectItem.isOn)
            let age = try ageTextField.validateText(validationType: .age)
            let targetWeight = try targetWeightTextField.validateText(validationType: .weight)
            let weight = try weightTextField.validateText(validationType: .weight)
            let height = try heightTextField.validateText(validationType: .height)
            
            let parameters: Parameters = [
                "name": name,
                "surname": surname,
                "email": email,
                "password": pass,
                "username": username,
                "gender": gender,
                "target_weight": targetWeight,
                "weight": weight,
                "age": age,
                "height": height
            ]
            AF.request("http://diyet.atwebpages.com/kayit", method: .post, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["success"].boolValue {
                        let result = JSON(json["result"].dictionaryValue)
                        
                        let data = LoginInfo(token: result["token"].stringValue, expiry_date: result["expiry_date"].stringValue, user_id: result["user_id"].intValue)
                        
                        UserDefaults.standard.set(data.token, forKey: "token")
                        UserDefaults.standard.set(data.user_id, forKey: "user_id")
                        UserDefaults.standard.set(data.expiry_date, forKey: "expiry_date")
                        
                        let homepage = self.storyboard?.instantiateViewController(withIdentifier: "HomePage")
                        self.show(homepage!, sender: nil)
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
    
    @IBAction func clearInputs(_ sender: Any) {
        nameTextField.text = ""
        surnameTextField.text = ""
        emailTextField.text = ""
        usernameTextField.text = ""
        passwordTextField.text = ""
        heightTextField.text = ""
        weightTextField.text = ""
        targetWeightTextField.text = ""
        ageTextField.text = ""
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
