//
//  LoginViewController.swift
//  Caloriender
//
//  Created by Uğur Güçer on 24.04.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let token:String = UserDefaults.standard.string(forKey: "token") ?? ""
        if(token.count == 32){
            let homepage = self.storyboard?.instantiateViewController(withIdentifier: "HomePage")
            self.show(homepage!, sender: nil)
        }
    }
    
    
    @IBAction func login(_ sender: Any) {
        do{
            let pass = try passwordTextField.validateText(validationType: .password)
            let username = try usernameTextField.validateText(validationType: .username)
            
            let parameters: Parameters = [
                "password": pass,
                "username": username
            ]
            AF.request("http://diyet.atwebpages.com/giris", method: .post, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["success"].boolValue {
                        let result = JSON(json["result"].dictionaryValue)
                        let df = DateFormatter()
                        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        
                        let data = LoginInfo(token: result["token"].stringValue, expiry_date: df.date(from: result["expiry_date"].stringValue)!, user_id: result["user_id"].intValue)
                        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
