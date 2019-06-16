//
//  MealDetailViewController.swift
//  Caloriender
//
//  Created by Uğur Güçer on 17.06.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MealDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalCalory: UILabel!
    @IBOutlet weak var mealTitle: UILabel!
    @IBOutlet weak var calories: UILabel!
    
    var result = [JSON]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = UserDefaults.standard.string(forKey: "token")!
        let meal_id = UserDefaults.standard.integer(forKey: "meal_id")
        AF.request("http://diyet.atwebpages.com/meal/read/"+token+"/\(meal_id)").validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json["success"].boolValue {
                    self.result = json["result"]["foods"].arrayValue
                    self.totalCalory.text = json["result"]["total_calories"].stringValue
                    self.calories.text = json["result"]["calories"].stringValue
                    self.mealTitle.text = json["result"]["title"].stringValue
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
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MealDetailCell", for: indexPath) as! MealDetailTableViewCell
        
        // Configure the cell...
        
        cell.amount.text = self.result[indexPath.row]["amount"].stringValue
        cell.calory.text = self.result[indexPath.row]["kalori"].stringValue
        cell.title.text = self.result[indexPath.row]["yiyecek"].stringValue
        
        return cell
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
