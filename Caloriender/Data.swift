//
//  LoginInfo.swift
//  Caloriender
//
//  Created by Uğur Güçer on 7.05.2019.
//  Copyright © 2019 Uğur Güçer. All rights reserved.
//

import Foundation

struct LoginInfo {
    var token: String
    var expiry_date: String
    var user_id: Int
}

struct ProfileInfo {
    var username: String
    var name: String
    var surname: String
    var height: Int
    var weight: Int
    var targetWeight: Int
    var age: Int
    var gender: Int
    var email: String
}
