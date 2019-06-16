//
//  LaunchScreenViewController.swift
//  Caloriender
//
//  Created by Uğur Güçer on 17.06.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddFoodViewController: UIViewController {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var calory: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addFood(_ sender: Any) {
        do{
            let nameText = try name.validateText(validationType: .nameOrSurname)
            let calories = try calory.validateText(validationType: .calories)
            
            let parameters: Parameters = [
                "yiyecek": nameText,
                "kalori": calories
            ]
            
            let token = UserDefaults.standard.string(forKey: "token")!
            AF.request("http://diyet.atwebpages.com/food/create/"+token, method: .post, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["success"].boolValue {
                        let alertController = UIAlertController(title: nil, message: json["message"].stringValue, preferredStyle: UIAlertController.Style.alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self.present(alertController, animated: true, completion: nil)
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
