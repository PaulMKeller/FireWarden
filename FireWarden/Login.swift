//
//  Login.swift
//  FireWarden
//
//  Created by Paul Keller on 12/5/17.
//  Copyright © 2017 PlanetKGames. All rights reserved.
//

import Foundation

class Login {
    var loginID: Int32 = 0
    var loginName: String = ""
    var password: String = ""
    var adminRole: NSDictionary
    
    init(loginID: Int32, loginName: String, password: String, adminRole: NSDictionary) {
        self.loginID = loginID
        self.loginName = loginName
        self.password = password
        self.adminRole = adminRole
    }
}
