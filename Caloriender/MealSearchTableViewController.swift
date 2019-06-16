//
//  MealSearchTableViewController.swift
//  Caloriender
//
//  Created by Uğur Güçer on 16.06.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire

class MealSearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var searchResults = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedFoods = [JSON]()
    let searchController = UISearchController(searchResultsController: nil)
    let searchRequest = SearchRequest()
    var previousRun = Date()
    let minInterval = 0.05
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.white
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        self.tableView.tableHeaderView?.backgroundColor = UIColor.white
        
        let backgroundViewLabel = UILabel(frame: .zero)
        backgroundViewLabel.textColor = .darkGray
        backgroundViewLabel.numberOfLines = 0
        tableView.backgroundView = backgroundViewLabel
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealSearch", for: indexPath) as! MealSearchTableViewCell
        
        cell.title.text = searchResults[indexPath.row]["yiyecek"].stringValue
        cell.calory.text = searchResults[indexPath.row]["kalori"].stringValue
        cell.add.tag = searchResults[indexPath.row]["food_id"].intValue
        if let amount = searchResults[indexPath.row]["amount"].object as? Int {
            cell.add.setTitle(String(amount), for: .normal)
        }
        // Configure the cell...
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            fetchResults(for: textToSearch)
        }
    }
    
    func fetchResults(for text: String) {
        searchRequest.search(searchText: text, completionHandler: {
            [weak self] results, error in
            if case .failure = error {
                return
            }
            
            guard let results = results, !results.isEmpty else {
                return
            }
            
            self?.searchResults = results
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if selectedFoods.count > 0 {
            let parameters: Parameters = [
                "meal_types_id": UserDefaults.standard.integer(forKey: "meal_type_id"),
                "foods": JSON(selectedFoods)
            ]
            let token = UserDefaults.standard.string(forKey: "token")!
            
            AF.request("http://diyet.atwebpages.com/meal/create/"+token, method: .post, parameters: parameters).validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    if json["success"].boolValue {
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
        }
    }

    @IBAction func addButton(_ sender: UIButton) {
        var dict2:[String : Any] = [:]
        if selectedFoods.count == 0 {
            dict2 = ["food_id": sender.tag, "amount": 1]
        }else{
            for var sf in self.selectedFoods {
                if sf["food_id"].intValue == sender.tag {
                    dict2 = ["food_id": sender.tag, "amount": sf["amount"].intValue + 1]
                    selectedFoods.removeAll(where:{ $0["food_id"].intValue == sender.tag })
                }else{
                    dict2 = ["food_id": sender.tag, "amount": 1]
                }
            }
        }
        
        self.selectedFoods.append(JSON(dict2))
        tableView.reloadData()
    }
    
    
    // Override to support conditional editing of the table view.
    /*
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
