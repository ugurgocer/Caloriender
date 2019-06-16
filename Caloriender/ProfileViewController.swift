//
//  ProfileViewController.swift
//  Caloriender
//
//  Created by Uğur Güçer on 7.05.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var nameSurname: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var targetWeight: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        let token = UserDefaults.standard.string(forKey: "token")!
        
        AF.request("http://diyet.atwebpages.com/user/read/"+token, method: .get, parameters: nil).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    let result = JSON(json["result"].dictionaryValue)
                    
                    let data = ProfileInfo(username: result["username"].stringValue, name: result["name"].stringValue, surname: result["surname"].stringValue, height: result["height"].intValue, weight: result["weight"].intValue, targetWeight: result["target_weight"].intValue, age: result["age"].intValue, gender: result["gender"].intValue, email: result["email"].stringValue)
                    
                    self.username.text = data.username
                    self.nameSurname.text = data.name+" "+data.surname
                    self.email.text = data.email
                    self.age.text = String(data.age)
                    self.weight.text = String(data.weight) + " kg"
                    self.height.text = String(data.height) + " cm"
                    self.targetWeight.text = String(data.targetWeight) + " kg"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func logout(_ sender: Any) {
        let parameters: Parameters = [
            "id": UserDefaults.standard.integer(forKey: "user_id"),
        ]
        
        AF.request("http://diyet.atwebpages.com/cikis", method: .post, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    
                    UserDefaults.standard.set("", forKey: "token")
                    UserDefaults.standard.set("", forKey: "user_id")
                    UserDefaults.standard.set("", forKey: "expiry_date")
                    
                    let homepage = self.storyboard?.instantiateViewController(withIdentifier: "LoginPage")
                    self.showDetailViewController(homepage!, sender: nil)
                } else {
                    let alertController = UIAlertController(title: nil, message: json["error"].stringValue, preferredStyle: UIAlertController.Style.alert)
                    print(json["error"])
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
            }
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
