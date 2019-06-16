//
//  BMIViewController.swift
//  Caloriender
//
//  Created by Uğur Güçer on 16.06.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BMIViewController: UIViewController {
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var result: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func calculate(_ sender: Any) {
        do{
            let weightValue = try weight.validateText(validationType: .weight)
            let heightValue = try height.validateText(validationType: .height)
            
            let parameters: Parameters = [
                "weight": weightValue,
                "height": heightValue
            ]
            
            let token = UserDefaults.standard.string(forKey: "token")!
            
            AF.request("http://diyet.atwebpages.com/calculate/body-mass-index/"+token, method: .post, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["success"].boolValue {
                        let data = JSON(json["result"].dictionaryValue)
                        
                        self.result.text = "Vücut Kütle Endeksi: "+data["body-mass-index"].stringValue + " kg/m2"
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
