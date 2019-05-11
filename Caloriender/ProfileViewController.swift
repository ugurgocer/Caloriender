//
//  ProfileViewController.swift
//  Caloriender
//
//  Created by Uğur Güçer on 7.05.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var LogOutButton: UIButton!
    @IBOutlet weak var UpdateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        LogOutButton.backgroundColor=UIColor.darkGray
        LogOutButton.layer.cornerRadius=self.LogOutButton.frame.height/3
        LogOutButton.setTitleColor(UIColor.white, for: .normal)
        UpdateButton.backgroundColor=UIColor.darkGray
        UpdateButton.layer.cornerRadius=self.UpdateButton.frame.height/3
        UpdateButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func LogOutAction(_ sender: UIButton) {
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
